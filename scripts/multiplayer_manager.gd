extends Node

signal status_changed(message: String)
signal lobby_changed(connected_players: int, is_host: bool)
signal duel_started(seed: int)
signal duel_finished(own_score: int, opponent_score: int, won: bool, draw: bool)

const DEFAULT_PORT: int = 28741
const MAX_CLIENTS: int = 1

var peer: ENetMultiplayerPeer
var hosting: bool = false
var duel_active: bool = false
var duel_scores: Dictionary = {}
var last_status: String = "Desconectado"


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func host_room(port: int = DEFAULT_PORT) -> bool:
	close_room()
	peer = ENetMultiplayerPeer.new()
	var error: int = peer.create_server(port, MAX_CLIENTS)
	if error != OK:
		_set_status("Nao foi possivel criar a sala (erro %d)." % error)
		peer = null
		return false
	multiplayer.multiplayer_peer = peer
	hosting = true
	duel_scores.clear()
	_set_status("Sala criada na porta %d. Aguardando outro jogador." % port)
	lobby_changed.emit(1, true)
	return true


func join_room(address: String, port: int = DEFAULT_PORT) -> bool:
	close_room()
	var clean_address: String = address.strip_edges()
	if clean_address == "":
		_set_status("Informe o IP do aparelho que criou a sala.")
		return false
	peer = ENetMultiplayerPeer.new()
	var error: int = peer.create_client(clean_address, port)
	if error != OK:
		_set_status("Nao foi possivel iniciar a conexao (erro %d)." % error)
		peer = null
		return false
	multiplayer.multiplayer_peer = peer
	hosting = false
	duel_scores.clear()
	_set_status("Conectando a %s:%d..." % [clean_address, port])
	return true


func close_room() -> void:
	duel_active = false
	duel_scores.clear()
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	if peer != null:
		peer.close()
	peer = null
	hosting = false


func has_active_peer() -> bool:
	return multiplayer.has_multiplayer_peer() and multiplayer.multiplayer_peer is ENetMultiplayerPeer


func connected_player_count() -> int:
	if not has_active_peer():
		return 0
	return 1 + multiplayer.get_peers().size()


func start_duel() -> bool:
	if not hosting:
		_set_status("Somente quem criou a sala pode iniciar a partida.")
		return false
	if connected_player_count() < 2:
		_set_status("Aguardando o segundo jogador entrar na sala.")
		return false
	duel_scores.clear()
	var seed_value: int = randi_range(1, 2147483646)
	_receive_duel_start.rpc(seed_value)
	return true


func submit_duel_score(value: int) -> void:
	if not duel_active or not has_active_peer():
		return
	if multiplayer.is_server():
		_store_duel_score(1, value)
	else:
		_submit_duel_score.rpc_id(1, value)


@rpc("authority", "call_local", "reliable")
func _receive_duel_start(seed_value: int) -> void:
	duel_active = true
	duel_scores.clear()
	_set_status("Duelo iniciado.")
	duel_started.emit(seed_value)


@rpc("any_peer", "call_remote", "reliable")
func _submit_duel_score(value: int) -> void:
	if not multiplayer.is_server():
		return
	_store_duel_score(multiplayer.get_remote_sender_id(), value)


func _store_duel_score(peer_id: int, value: int) -> void:
	duel_scores[peer_id] = maxi(0, value)
	if duel_scores.size() < 2:
		_set_status("Resultado enviado. Aguardando o outro jogador.")
		return
	_finish_duel.rpc(duel_scores)


@rpc("authority", "call_local", "reliable")
func _finish_duel(scores: Dictionary) -> void:
	var own_id: int = multiplayer.get_unique_id()
	var own_score: int = int(scores.get(own_id, 0))
	var opponent_score: int = 0
	for id in scores.keys():
		if int(id) != own_id:
			opponent_score = int(scores[id])
			break
	var draw: bool = own_score == opponent_score
	var won: bool = own_score > opponent_score
	duel_active = false
	_set_status("Duelo encerrado.")
	duel_finished.emit(own_score, opponent_score, won, draw)


func _on_peer_connected(_id: int) -> void:
	_set_status("Jogador conectado. A sala esta pronta.")
	lobby_changed.emit(connected_player_count(), hosting)


func _on_peer_disconnected(_id: int) -> void:
	duel_active = false
	duel_scores.clear()
	_set_status("O outro jogador saiu da sala.")
	lobby_changed.emit(connected_player_count(), hosting)


func _on_connected_to_server() -> void:
	_set_status("Conectado a sala. Aguarde o anfitriao iniciar.")
	lobby_changed.emit(connected_player_count(), false)


func _on_connection_failed() -> void:
	close_room()
	_set_status("Falha ao conectar. Confira o IP, a porta e a rede Wi-Fi.")
	lobby_changed.emit(0, false)


func _on_server_disconnected() -> void:
	close_room()
	_set_status("A sala foi encerrada pelo anfitriao.")
	lobby_changed.emit(0, false)


func _set_status(message: String) -> void:
	last_status = message
	status_changed.emit(message)
