extends SceneTree

var role: String = ""
var duel_started_received: bool = false
var duel_finished_received: bool = false
var final_own_score: int = -1
var final_opponent_score: int = -1


func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--role="):
			role = argument.trim_prefix("--role=")
	call_deferred("_run")


func _run() -> void:
	var manager: Node = root.get_node_or_null("MultiplayerManager")
	if manager == null:
		_fail("MultiplayerManager autoload ausente")
		return
	manager.duel_started.connect(_on_duel_started)
	manager.duel_finished.connect(_on_duel_finished)
	if role == "host":
		if not manager.host_room(29841):
			_fail("host_room falhou")
			return
		if not await _wait_until(func() -> bool: return manager.connected_player_count() == 2, 8.0):
			_fail("cliente nao conectou")
			return
		if not manager.start_duel():
			_fail("start_duel falhou")
			return
		if not await _wait_until(func() -> bool: return duel_started_received, 3.0):
			_fail("host nao recebeu duel_started")
			return
		manager.submit_duel_score(7)
	else:
		if not manager.join_room("127.0.0.1", 29841):
			_fail("join_room falhou")
			return
		if not await _wait_until(func() -> bool: return duel_started_received, 8.0):
			_fail("cliente nao recebeu duel_started")
			return
		manager.submit_duel_score(5)
	if not await _wait_until(func() -> bool: return duel_finished_received, 5.0):
		_fail("resultado nao foi recebido")
		return
	print("MULTIPLAYER_SMOKE_OK role=%s own=%d opponent=%d" % [role, final_own_score, final_opponent_score])
	if role == "host":
		await _wait_until(func() -> bool: return false, 0.5)
	manager.close_room()
	quit(0)


func _wait_until(predicate: Callable, timeout_seconds: float) -> bool:
	var deadline: int = Time.get_ticks_msec() + int(timeout_seconds * 1000.0)
	while Time.get_ticks_msec() < deadline:
		if predicate.call():
			return true
		await process_frame
	return false


func _on_duel_started(_seed: int) -> void:
	duel_started_received = true


func _on_duel_finished(own_score: int, opponent_score: int, _won: bool, _draw: bool) -> void:
	duel_finished_received = true
	final_own_score = own_score
	final_opponent_score = opponent_score


func _fail(message: String) -> void:
	push_error("MULTIPLAYER_SMOKE_FAIL: %s" % message)
	quit(1)
