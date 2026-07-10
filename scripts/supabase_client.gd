extends Node

signal auth_changed
signal sync_status_changed(message: String)

const SESSION_PATH: String = "user://memiq_supabase_session.cfg"

# Preencha estes valores comigo quando voce enviar os dados do projeto Supabase.
# Use somente a chave publica anon/publishable. Nunca use service_role no app.
const PROJECT_URL: String = "https://rsjivqhrkzofvrzxuznq.supabase.co"
const PUBLIC_ANON_KEY: String = "sb_publishable_znu2D4Z64hAX48EkoZpvHQ_P33NZD5v"

var access_token: String = ""
var refresh_token: String = ""
var user_id: String = ""
var user_email: String = ""
var is_anonymous: bool = false
var last_error: String = ""
var syncing: bool = false


func _ready() -> void:
	_load_session()
	if typeof(ScoreStore) != TYPE_NIL and ScoreStore.has_signal("data_changed"):
		ScoreStore.data_changed.connect(_on_score_store_changed)


func is_configured() -> bool:
	return PROJECT_URL.strip_edges() != "" and PUBLIC_ANON_KEY.strip_edges() != ""


func is_signed_in() -> bool:
	return access_token != "" and user_id != ""


func auth_label() -> String:
	if not is_configured():
		return "Supabase nao configurado"
	if not is_signed_in():
		return "Offline"
	if is_anonymous:
		return "Anonimo conectado"
	return "Conectado: %s" % user_email


func sign_up(display_name: String, email: String, password: String) -> bool:
	if not _require_config():
		return false
	var clean_name: String = display_name.strip_edges()
	var clean_email: String = email.strip_edges()
	if clean_name == "":
		last_error = "Informe o nome do usuario."
		sync_status_changed.emit(last_error)
		return false
	if clean_email == "" or password == "":
		last_error = "Informe email e senha para criar a conta."
		sync_status_changed.emit(last_error)
		return false
	ScoreStore.update_profile(clean_name, ScoreStore.avatar_id, ScoreStore.banner_id, ScoreStore.name_style, ScoreStore.featured_achievement)
	var result: Dictionary = await _auth_request("/signup", {
		"email": clean_email,
		"password": password,
		"data": {"display_name": clean_name}
	})
	if result.has("error"):
		last_error = String(result["error"])
		sync_status_changed.emit(last_error)
		return false
	var access: String = String(result.get("access_token", ""))
	if access == "":
		user_email = clean_email
		last_error = "Conta criada. Enviamos um email de confirmacao para %s. Confirme o email antes de entrar." % clean_email
		sync_status_changed.emit(last_error)
		return true
	if not _store_auth_result(result):
		return false
	await _ensure_profile()
	await sync_progress()
	return true


func sign_in(email: String, password: String) -> bool:
	if not _require_config():
		return false
	var result: Dictionary = await _auth_request("/token?grant_type=password", {
		"email": email.strip_edges(),
		"password": password
	})
	if not _store_auth_result(result):
		return false
	await _ensure_profile()
	await load_cloud_progress()
	return true


func sign_out() -> void:
	if is_configured() and access_token != "":
		await _auth_request("/logout", {}, true)
	access_token = ""
	refresh_token = ""
	user_id = ""
	user_email = ""
	is_anonymous = false
	_save_session()
	auth_changed.emit()
	sync_status_changed.emit("Conta desconectada")


func sync_progress() -> bool:
	if syncing or not is_signed_in():
		return false
	syncing = true
	var body: Dictionary = ScoreStore.to_cloud_payload()
	body["user_id"] = user_id
	var result: Variant = await _rest_request("/player_progress?on_conflict=user_id", HTTPClient.METHOD_POST, body, "resolution=merge-duplicates,return=representation")
	syncing = false
	if result is Dictionary and result.has("error"):
		last_error = String(result["error"])
		sync_status_changed.emit("Falha ao salvar na nuvem: %s" % last_error)
		return false
	await _sync_leaderboard_entry()
	sync_status_changed.emit("Progresso salvo na nuvem")
	return true


func load_cloud_progress() -> bool:
	if not is_signed_in():
		return false
	var path: String = "/player_progress?user_id=eq.%s&select=*" % user_id.uri_encode()
	var result: Variant = await _rest_request(path, HTTPClient.METHOD_GET)
	if not (result is Array) or result.size() == 0:
		return await sync_progress()
	ScoreStore.apply_cloud_payload(result[0])
	sync_status_changed.emit("Progresso carregado da nuvem")
	return true


func save_profile() -> bool:
	if not is_signed_in():
		return false
	var body: Dictionary = {
		"id": user_id,
		"display_name": ScoreStore.display_name,
		"avatar_id": ScoreStore.avatar_id,
		"banner_id": ScoreStore.banner_id,
		"name_style": ScoreStore.name_style,
		"featured_achievement": ScoreStore.featured_achievement
	}
	var result: Variant = await _rest_request("/profiles?on_conflict=id", HTTPClient.METHOD_POST, body, "resolution=merge-duplicates,return=representation")
	return not (result is Dictionary and result.has("error"))


func record_match(mode: String, opponent_id: String, won: bool, player_score: int, opponent_score: int) -> void:
	if not is_signed_in():
		return
	var body: Dictionary = {
		"user_id": user_id,
		"mode": mode,
		"opponent_id": null if opponent_id == "" else opponent_id,
		"result": "win" if won else "loss",
		"player_score": player_score,
		"opponent_score": opponent_score,
		"rating_after": ScoreStore.multiplayer_rating,
		"rank_after": ScoreStore.rank_name
	}
	await _rest_request("/match_history", HTTPClient.METHOD_POST, body)


func fetch_match_history(limit: int = 20) -> Array:
	if not is_signed_in():
		return []
	var path: String = "/match_history?user_id=eq.%s&select=*&order=created_at.desc&limit=%d" % [user_id.uri_encode(), limit]
	var result: Variant = await _rest_request(path, HTTPClient.METHOD_GET)
	return result if result is Array else []


func fetch_leaderboard(limit: int = 50) -> Array:
	var result: Variant = await _rest_request("/leaderboard_entries?select=*&order=multiplayer_rating.desc&limit=%d" % limit, HTTPClient.METHOD_GET)
	return result if result is Array else []


func _on_score_store_changed() -> void:
	if is_signed_in():
		call_deferred("sync_progress")


func _ensure_profile() -> void:
	await save_profile()


func _sync_leaderboard_entry() -> void:
	if not is_signed_in():
		return
	var body: Dictionary = {
		"user_id": user_id,
		"display_name": ScoreStore.display_name,
		"avatar_id": ScoreStore.avatar_id,
		"multiplayer_rating": ScoreStore.multiplayer_rating,
		"rank_name": ScoreStore.rank_name,
		"multiplayer_wins": ScoreStore.multiplayer_wins,
		"multiplayer_losses": ScoreStore.multiplayer_losses
	}
	await _rest_request("/leaderboard_entries?on_conflict=user_id", HTTPClient.METHOD_POST, body, "resolution=merge-duplicates")


func _require_config() -> bool:
	if is_configured():
		return true
	last_error = "Informe PROJECT_URL e PUBLIC_ANON_KEY em scripts/supabase_client.gd"
	sync_status_changed.emit(last_error)
	return false


func _auth_request(path: String, body: Dictionary, use_user_token: bool = false) -> Dictionary:
	var headers: PackedStringArray = _base_headers(use_user_token)
	var result: Variant = await _http_json("%s/auth/v1%s" % [PROJECT_URL.trim_suffix("/"), path], HTTPClient.METHOD_POST, headers, body)
	return result if result is Dictionary else {"error": "Resposta invalida do Auth"}


func _rest_request(path: String, method: int, body: Variant = null, prefer: String = "") -> Variant:
	if not _require_config():
		return {"error": last_error}
	var headers: PackedStringArray = _base_headers(true)
	if prefer != "":
		headers.append("Prefer: %s" % prefer)
	var url: String = "%s/rest/v1%s" % [PROJECT_URL.trim_suffix("/"), path]
	return await _http_json(url, method, headers, body)


func _http_json(url: String, method: int, headers: PackedStringArray, body: Variant = null) -> Variant:
	var request: HTTPRequest = HTTPRequest.new()
	add_child(request)
	var json_body: String = "" if body == null else JSON.stringify(body)
	var error: int = request.request(url, headers, method, json_body)
	if error != OK:
		request.queue_free()
		last_error = "HTTPRequest erro %d" % error
		return {"error": last_error}
	var response: Array = await request.request_completed
	request.queue_free()
	var status: int = int(response[1])
	var bytes: PackedByteArray = response[3]
	var text: String = bytes.get_string_from_utf8()
	var parsed: Variant = null
	if text.strip_edges() != "":
		parsed = JSON.parse_string(text)
	if status < 200 or status >= 300:
		last_error = _extract_error(parsed, status)
		return {"error": last_error, "status": status}
	return parsed


func _base_headers(use_user_token: bool) -> PackedStringArray:
	var token: String = access_token if use_user_token and access_token != "" else PUBLIC_ANON_KEY
	return PackedStringArray([
		"apikey: %s" % PUBLIC_ANON_KEY,
		"Authorization: Bearer %s" % token,
		"Content-Type: application/json"
	])


func _store_auth_result(result: Dictionary) -> bool:
	if result.has("error"):
		last_error = String(result["error"])
		sync_status_changed.emit(last_error)
		return false
	var user: Dictionary = result.get("user", {})
	if user.is_empty():
		last_error = "Auth nao retornou usuario. Verifique a confirmacao do email."
		sync_status_changed.emit(last_error)
		return false
	access_token = String(result.get("access_token", ""))
	refresh_token = String(result.get("refresh_token", ""))
	user_id = String(user.get("id", ""))
	user_email = String(user.get("email", ""))
	is_anonymous = bool(user.get("is_anonymous", user_email == ""))
	last_error = ""
	_save_session()
	auth_changed.emit()
	sync_status_changed.emit(auth_label())
	return access_token != "" and user_id != ""


func _extract_error(parsed: Variant, status: int) -> String:
	if parsed is Dictionary:
		if parsed.has("msg"):
			return String(parsed["msg"])
		if parsed.has("message"):
			return String(parsed["message"])
		if parsed.has("error_description"):
			return String(parsed["error_description"])
	return "Erro HTTP %d" % status


func _load_session() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(SESSION_PATH) != OK:
		return
	access_token = String(config.get_value("auth", "access_token", ""))
	refresh_token = String(config.get_value("auth", "refresh_token", ""))
	user_id = String(config.get_value("auth", "user_id", ""))
	user_email = String(config.get_value("auth", "user_email", ""))
	is_anonymous = bool(config.get_value("auth", "is_anonymous", false))


func _save_session() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("auth", "access_token", access_token)
	config.set_value("auth", "refresh_token", refresh_token)
	config.set_value("auth", "user_id", user_id)
	config.set_value("auth", "user_email", user_email)
	config.set_value("auth", "is_anonymous", is_anonymous)
	config.save(SESSION_PATH)
