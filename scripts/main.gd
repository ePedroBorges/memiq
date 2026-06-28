extends Control

const SPLASH_SECONDS: float = 2.2
const ACHIEVEMENTS: Array[Dictionary] = [
	{"id": "first_signal", "name": "Primeiro Sinal", "requirement": "Jogue sua primeira partida.", "type": "games", "value": 1},
	{"id": "games_10", "name": "Rotina de Treino", "requirement": "Jogue 10 partidas.", "type": "games", "value": 10},
	{"id": "games_25", "name": "Presenca Constante", "requirement": "Jogue 25 partidas.", "type": "games", "value": 25},
	{"id": "infinite_10", "name": "Sequencia Limpa", "requirement": "Alcance 10 pontos no Infinito.", "type": "survival", "value": 10},
	{"id": "infinite_25", "name": "Reflexo Neon", "requirement": "Alcance 25 pontos no Infinito.", "type": "survival", "value": 25},
	{"id": "infinite_50", "name": "Memoria de Aco", "requirement": "Alcance 50 pontos no Infinito.", "type": "survival", "value": 50},
	{"id": "infinite_100", "name": "Lenda do Loop", "requirement": "Alcance 100 pontos no Infinito.", "type": "survival", "value": 100},
	{"id": "level_2", "name": "Nivel 2", "requirement": "Suba para o nivel 2.", "type": "level", "value": 2},
	{"id": "level_5", "name": "Jogador Focado", "requirement": "Suba para o nivel 5.", "type": "level", "value": 5},
	{"id": "level_10", "name": "Mestre RGB", "requirement": "Suba para o nivel 10.", "type": "level", "value": 10},
	{"id": "level_20", "name": "Circuito Lendario", "requirement": "Suba para o nivel 20.", "type": "level", "value": 20},
	{"id": "rewards_4", "name": "Primeira Colecao", "requirement": "Desbloqueie 4 recompensas.", "type": "rewards", "value": 4},
	{"id": "rewards_8", "name": "Inventario Neon", "requirement": "Desbloqueie 8 recompensas.", "type": "rewards", "value": 8},
	{"id": "rewards_12", "name": "Vitrine Premium", "requirement": "Desbloqueie 12 recompensas.", "type": "rewards", "value": 12},
]
const REWARDS: Array[Dictionary] = [
	{"id": "bg_neon", "kind": "background", "name": "Fundo Neon Grid", "requirement": "Inicial", "level": 1},
	{"id": "board_classic", "kind": "board", "name": "Genius Classico RGB", "requirement": "Inicial", "level": 1},
	{"id": "bg_aurora", "kind": "background", "name": "Fundo Aurora", "requirement": "Alcance o nivel 2", "level": 2},
	{"id": "board_plasma", "kind": "board", "name": "Genius Plasma", "requirement": "Alcance o nivel 3", "level": 3},
	{"id": "bg_sunset", "kind": "background", "name": "Fundo Sunset", "requirement": "Alcance o nivel 4", "level": 4},
	{"id": "board_solar", "kind": "board", "name": "Genius Solar", "requirement": "Alcance o nivel 5", "level": 5},
	{"id": "bg_cyber", "kind": "background", "name": "Fundo Cyber Blue", "requirement": "Alcance o nivel 6", "level": 6},
	{"id": "board_crystal", "kind": "board", "name": "Genius Crystal", "requirement": "Alcance o nivel 7", "level": 7},
	{"id": "bg_void", "kind": "background", "name": "Fundo Void", "requirement": "Alcance o nivel 8", "level": 8},
	{"id": "board_void", "kind": "board", "name": "Genius Void", "requirement": "Alcance o nivel 9", "level": 9},
	{"id": "bg_arcade", "kind": "background", "name": "Fundo Arcade Pop", "requirement": "Alcance o nivel 11", "level": 11},
	{"id": "board_candy", "kind": "board", "name": "Genius Candy", "requirement": "Alcance o nivel 12", "level": 12},
	{"id": "bg_lime", "kind": "background", "name": "Fundo Lime Pulse", "requirement": "Alcance o nivel 15", "level": 15},
	{"id": "board_midnight", "kind": "board", "name": "Genius Midnight", "requirement": "Alcance o nivel 16", "level": 16},
]

var flash_time: float = 0.46
var sequence: Array[int] = []
var input_index: int = 0
var score: int = 0
var accepting_input: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var session_id: int = 0
var current_back_target: String = "menu"
var screen_state: String = "menu"
var responsive_layout_queued: bool = false

var root_box: VBoxContainer
var top_bar: HBoxContainer
var back_button: Button
var top_spacer: Control
var title_label: Label
var subtitle_label: Label
var score_label: Label
var status_label: Label
var board: Control
var content_scroll: ScrollContainer
var content_box: VBoxContainer
var action_row: VBoxContainer
var main_margin: MarginContainer
var menu_logo: Control
var menu_spacer: Control
var background_layer: Control
var hud_panel: PanelContainer
var hud_record_label: Label
var hud_points_label: Label
var hud_level_label: Label
var hud_xp_label: Label
var hud_xp_bar: ProgressBar
var hud_reward_label: Label
var options_button: Button
var in_game_options: PanelContainer
var mute_button: Button
var menu_button: Button
var audio_player: AudioStreamPlayer
var splash_layer: CanvasLayer
var splash_root: Control


func _ready() -> void:
	rng.randomize()
	_build_ui()
	resized.connect(_queue_responsive_layout)
	if get_viewport().has_signal("size_changed"):
		get_viewport().connect("size_changed", Callable(self, "_queue_responsive_layout"))
	call_deferred("_apply_responsive_layout")
	_show_splash()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_queue_responsive_layout()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_handle_back_request()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_handle_back_request()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	background_layer = preload("res://scripts/neon_background.gd").new()
	background_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background_layer)

	main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(main_margin)

	var shell: HBoxContainer = HBoxContainer.new()
	shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell.alignment = BoxContainer.ALIGNMENT_CENTER
	main_margin.add_child(shell)

	var left_spacer: Control = Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.add_child(left_spacer)

	root_box = VBoxContainer.new()
	root_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	root_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.alignment = BoxContainer.ALIGNMENT_CENTER
	root_box.add_theme_constant_override("separation", 12)
	shell.add_child(root_box)

	var right_spacer: Control = Control.new()
	right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell.add_child(right_spacer)

	top_bar = HBoxContainer.new()
	top_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	top_bar.add_theme_constant_override("separation", 8)
	root_box.add_child(top_bar)

	back_button = _make_icon_button("<", _on_back_pressed)
	top_bar.add_child(back_button)

	var title_area: VBoxContainer = VBoxContainer.new()
	title_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_area.alignment = BoxContainer.ALIGNMENT_CENTER
	top_bar.add_child(title_area)

	title_label = _make_label("MEMIQ", 38, Color(0.94, 0.98, 1.0))
	title_area.add_child(title_label)

	subtitle_label = _make_label("", 16, Color(0.66, 0.78, 0.92))
	title_area.add_child(subtitle_label)

	top_spacer = Control.new()
	top_spacer.custom_minimum_size = Vector2(52, 46)
	top_bar.add_child(top_spacer)

	menu_logo = preload("res://scripts/memiq_logo.gd").new()
	menu_logo.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_child(menu_logo)

	score_label = _make_label("", 18, Color(0.9, 0.96, 1.0))
	root_box.add_child(score_label)

	board = preload("res://scripts/genius_board.gd").new()
	board.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	board.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	board.pad_pressed.connect(_on_pad_pressed)
	root_box.add_child(board)

	status_label = _make_label("", 18, Color(0.82, 0.9, 1.0))
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root_box.add_child(status_label)

	content_scroll = ScrollContainer.new()
	content_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_scroll.follow_focus = true
	root_box.add_child(content_scroll)

	content_box = VBoxContainer.new()
	content_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.alignment = BoxContainer.ALIGNMENT_CENTER
	content_box.add_theme_constant_override("separation", 12)
	content_scroll.add_child(content_box)

	action_row = VBoxContainer.new()
	action_row.alignment = BoxContainer.ALIGNMENT_CENTER
	action_row.add_theme_constant_override("separation", 10)
	root_box.add_child(action_row)

	menu_spacer = Control.new()
	menu_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.add_child(menu_spacer)
	root_box.move_child(menu_logo, 1)
	root_box.move_child(menu_spacer, root_box.get_child_count() - 1)

	options_button = _make_icon_button("III", _toggle_options_panel)
	options_button.position = Vector2(18, 18)
	options_button.visible = false
	add_child(options_button)

	hud_panel = PanelContainer.new()
	hud_panel.visible = false
	hud_panel.add_theme_stylebox_override("panel", _button_style(Color(0.006, 0.012, 0.026, 0.82), Color(0.0, 0.78, 1.0, 0.72), 12))
	add_child(hud_panel)

	var hud_box: VBoxContainer = VBoxContainer.new()
	hud_box.add_theme_constant_override("separation", 5)
	hud_panel.add_child(hud_box)

	var hud_stats: HBoxContainer = HBoxContainer.new()
	hud_stats.alignment = BoxContainer.ALIGNMENT_CENTER
	hud_stats.add_theme_constant_override("separation", 16)
	hud_box.add_child(hud_stats)

	hud_record_label = _make_label("", 13, Color(0.72, 0.9, 1.0))
	hud_points_label = _make_label("", 16, Color(0.96, 0.99, 1.0))
	hud_level_label = _make_label("", 13, Color(1.0, 0.78, 0.28))
	hud_record_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_points_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_stats.add_child(hud_record_label)
	hud_stats.add_child(hud_points_label)
	hud_stats.add_child(hud_level_label)

	hud_xp_bar = ProgressBar.new()
	hud_xp_bar.show_percentage = false
	hud_xp_bar.custom_minimum_size = Vector2(300, 10)
	hud_xp_bar.add_theme_stylebox_override("background", _bar_style(Color(0.02, 0.04, 0.075, 0.94), Color(0.0, 0.36, 0.55, 0.55)))
	hud_xp_bar.add_theme_stylebox_override("fill", _bar_style(Color(0.0, 0.82, 1.0, 0.88), Color(0.58, 1.0, 0.92, 0.9)))
	hud_box.add_child(hud_xp_bar)

	hud_xp_label = _make_label("", 12, Color(0.74, 0.84, 0.96))
	hud_box.add_child(hud_xp_label)

	hud_reward_label = _make_label("", 15, Color(1.0, 0.78, 0.28))
	hud_reward_label.visible = false
	add_child(hud_reward_label)

	in_game_options = PanelContainer.new()
	in_game_options.position = Vector2(18, 78)
	in_game_options.visible = false
	in_game_options.add_theme_stylebox_override("panel", _button_style(Color(0.006, 0.012, 0.026, 0.94), Color(0.0, 0.78, 1.0, 0.62), 12))
	add_child(in_game_options)

	var options_box: VBoxContainer = VBoxContainer.new()
	options_box.add_theme_constant_override("separation", 8)
	in_game_options.add_child(options_box)

	mute_button = _make_button("", _toggle_audio)
	mute_button.custom_minimum_size = Vector2(156, 44)
	options_box.add_child(mute_button)

	menu_button = _make_button("MENU", _show_menu)
	menu_button.custom_minimum_size = Vector2(156, 44)
	options_box.add_child(menu_button)

	audio_player = AudioStreamPlayer.new()
	audio_player.stream = AudioStreamGenerator.new()
	audio_player.volume_db = -8.0
	add_child(audio_player)

	root_box.visible = false
	_apply_unlocked_visuals()


func _show_splash() -> void:
	splash_layer = CanvasLayer.new()
	splash_layer.layer = 20
	add_child(splash_layer)

	splash_root = Control.new()
	splash_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_layer.add_child(splash_root)

	var splash_background: ColorRect = ColorRect.new()
	splash_background.color = Color.BLACK
	splash_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_root.add_child(splash_background)

	var viewport_size: Vector2 = get_viewport_rect().size
	var safe_insets: Vector4 = _safe_insets(viewport_size)
	var safe_margin: MarginContainer = MarginContainer.new()
	safe_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	safe_margin.add_theme_constant_override("margin_left", int(maxf(28.0, safe_insets.x + 24.0)))
	safe_margin.add_theme_constant_override("margin_right", int(maxf(28.0, safe_insets.z + 24.0)))
	safe_margin.add_theme_constant_override("margin_top", int(maxf(48.0, safe_insets.y + 36.0)))
	safe_margin.add_theme_constant_override("margin_bottom", int(maxf(48.0, safe_insets.w + 36.0)))
	splash_root.add_child(safe_margin)

	var center: CenterContainer = CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe_margin.add_child(center)

	var logo: TextureRect = TextureRect.new()
	logo.texture = _load_png_texture("res://assets/anchorlab.png")
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var logo_width: float = minf(viewport_size.x * 0.78, 560.0)
	var logo_height: float = minf(viewport_size.y * 0.34, 360.0)
	logo.custom_minimum_size = Vector2(logo_width, logo_height)
	center.add_child(logo)

	await get_tree().create_timer(SPLASH_SECONDS).timeout
	var tween: Tween = create_tween()
	tween.tween_property(splash_root, "modulate:a", 0.0, 0.35)
	await tween.finished
	splash_layer.queue_free()
	root_box.visible = true
	_show_menu()


func _load_png_texture(path: String) -> Texture2D:
	var texture: Texture2D = load(path) as Texture2D
	if texture == null:
		return null
	return texture


func _show_menu() -> void:
	session_id += 1
	screen_state = "menu"
	_clear_boxes()
	_set_back_target("")
	_set_game_chrome(false)
	_set_menu_logo_visible(true)
	_apply_unlocked_visuals()
	root_box.alignment = BoxContainer.ALIGNMENT_CENTER
	top_bar.visible = false
	content_scroll.visible = false
	action_row.visible = true
	board.visible = false
	board.enabled = false
	title_label.visible = false
	subtitle_label.visible = false
	score_label.visible = false
	status_label.visible = false

	action_row.add_child(_make_button("INFINITO", _start_survival))
	action_row.add_child(_make_button("CUSTOMIZACAO", _show_customization))
	action_row.add_child(_make_button("CONFIGURACOES", _show_settings))
	action_row.add_child(_make_button("CONQUISTAS  %d/%d" % [_achievement_count(), ACHIEVEMENTS.size()], _show_achievements))
	action_row.add_child(_make_button("RECOMPENSAS  %d/%d" % [ScoreStore.unlocked_reward_count(), REWARDS.size()], _show_rewards))
	_apply_interface_theme()
	_apply_responsive_layout()


func _show_achievements() -> void:
	_show_collection_screen("CONQUISTAS", "%d/%d desbloqueadas" % [_achievement_count(), ACHIEVEMENTS.size()], "Objetivos permanentes para dominar o Infinito.")
	for achievement in ACHIEVEMENTS:
		content_box.add_child(_make_achievement_card(achievement))
	_apply_responsive_layout()


func _show_rewards() -> void:
	_show_collection_screen("RECOMPENSAS", "%d/%d liberadas" % [ScoreStore.unlocked_reward_count(), REWARDS.size()], "Itens ganhados ao subir de nivel.")
	for reward in REWARDS:
		content_box.add_child(_make_reward_card(reward, false))
	_apply_responsive_layout()


func _show_customization() -> void:
	_show_collection_screen("CUSTOMIZACAO", "Fundo e estilo do Genius", "Escolha os itens ja liberados.")
	content_box.add_child(_make_section_label("FUNDOS"))
	for reward in REWARDS:
		if String(reward["kind"]) == "background":
			content_box.add_child(_make_reward_card(reward, true))
	content_box.add_child(_make_section_label("GENIUS"))
	for reward in REWARDS:
		if String(reward["kind"]) == "board":
			content_box.add_child(_make_reward_card(reward, true))
	_apply_responsive_layout()


func _show_settings() -> void:
	_show_collection_screen("CONFIGURACOES", "Preferencias do jogo", "Ajustes salvos automaticamente.")
	content_box.add_child(_make_section_label("TEMA"))
	content_box.add_child(_make_button("TEMA CLARO" if not ScoreStore.is_light_theme() else "TEMA CLARO  // ATIVO", Callable(self, "_set_visual_theme").bind("light")))
	content_box.add_child(_make_button("TEMA ESCURO" if ScoreStore.is_light_theme() else "TEMA ESCURO  // ATIVO", Callable(self, "_set_visual_theme").bind("dark")))
	content_box.add_child(_make_section_label("AUDIO"))
	content_box.add_child(_make_button("AUDIO: OFF" if ScoreStore.audio_muted else "AUDIO: ON", _toggle_audio_from_settings))
	_apply_responsive_layout()


func _show_collection_screen(screen_title: String, screen_subtitle: String, detail: String) -> void:
	session_id += 1
	screen_state = "collection"
	_clear_boxes()
	_set_back_target("menu")
	_set_game_chrome(false)
	_set_menu_logo_visible(false)
	root_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	top_bar.visible = true
	content_scroll.visible = true
	action_row.visible = false
	board.visible = false
	title_label.visible = true
	subtitle_label.visible = true
	score_label.visible = false
	status_label.visible = true
	title_label.text = screen_title
	subtitle_label.text = screen_subtitle
	status_label.text = detail
	_apply_interface_theme()


func _start_survival() -> void:
	session_id += 1
	screen_state = "game"
	var current_session: int = session_id
	_clear_boxes()
	_set_back_target("menu")
	_set_game_chrome(true)
	_set_menu_logo_visible(false)
	top_bar.visible = false
	content_scroll.visible = false
	action_row.visible = false
	board.visible = true
	title_label.visible = false
	subtitle_label.visible = false
	score_label.visible = false
	status_label.visible = false
	sequence.clear()
	score = 0
	input_index = 0
	flash_time = _flash_time_for_level()
	accepting_input = false
	root_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_apply_unlocked_visuals()
	_update_score_label()
	_update_hud()
	_apply_responsive_layout()
	await get_tree().create_timer(0.65).timeout
	if current_session == session_id:
		_next_round(current_session)


func _next_round(current_session: int) -> void:
	if current_session != session_id:
		return
	accepting_input = false
	board.enabled = false
	input_index = 0
	sequence.append(rng.randi_range(0, 3))
	_update_score_label()
	await get_tree().create_timer(0.3).timeout
	if current_session != session_id:
		return
	for color_index in sequence:
		_play_pad_tone(color_index, 0.18)
		await board.flash_pad(color_index, flash_time)
		if current_session != session_id:
			return
		await get_tree().create_timer(maxf(0.07, flash_time * 0.3)).timeout
		if current_session != session_id:
			return
	accepting_input = true
	board.enabled = true


func _on_pad_pressed(index: int) -> void:
	if not accepting_input:
		return
	var current_session: int = session_id
	accepting_input = false
	board.enabled = false
	_play_pad_tone(index, 0.12)
	await board.flash_pad(index, 0.2)
	if current_session != session_id:
		return
	if sequence[input_index] != index:
		_show_error_feedback()
		await get_tree().create_timer(0.45).timeout
		if current_session == session_id:
			_finish_game()
		return

	input_index += 1
	if input_index >= sequence.size():
		score += 1
		_show_success_feedback()
		var previous_level: int = ScoreStore.survival_level
		ScoreStore.add_survival_xp(_xp_for_score(score))
		flash_time = _flash_time_for_level()
		var reward_names: Array[String] = _unlock_due_rewards()
		_check_achievements()
		_show_reward_notice(reward_names, previous_level)
		await get_tree().create_timer(0.42).timeout
		if current_session == session_id:
			_next_round(current_session)
	else:
		accepting_input = true
		board.enabled = true
	_update_score_label()
	_update_hud()


func _finish_game() -> void:
	session_id += 1
	screen_state = "game_over"
	accepting_input = false
	board.enabled = false
	_clear_boxes()
	_set_back_target("menu")
	_set_game_chrome(false)
	board.visible = false
	root_box.alignment = BoxContainer.ALIGNMENT_CENTER

	var new_record: bool = ScoreStore.record_survival(score)
	_check_achievements()
	_update_hud()
	hud_panel.visible = true
	top_bar.visible = false
	content_scroll.visible = true
	title_label.visible = false
	subtitle_label.visible = false
	status_label.visible = false
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.alignment = BoxContainer.ALIGNMENT_CENTER
	var result_top_spacer: Control = Control.new()
	result_top_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.add_child(result_top_spacer)
	var result_title: Label = _make_label("NOVO RECORDE" if new_record else "FIM DE JOGO", 30, Color(0.96, 0.99, 1.0))
	var result_score: Label = _make_label("Pontuacao: %d" % score, 16, Color(0.72, 0.84, 1.0))
	content_box.add_child(result_title)
	content_box.add_child(result_score)
	content_box.add_child(_make_button("JOGAR NOVAMENTE", _start_survival))
	content_box.add_child(_make_button("MENU", _show_menu))
	var result_bottom_spacer: Control = Control.new()
	result_bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.add_child(result_bottom_spacer)
	_apply_responsive_layout()


func _update_score_label() -> void:
	score_label.text = "Pontuacao: %d" % score


func _clear_boxes() -> void:
	for child in content_box.get_children():
		child.queue_free()
	for child in action_row.get_children():
		child.queue_free()


func _make_button(text: String, callback: Callable) -> Button:
	var button: Button = Button.new()
	var normal_fill: Color = Color(0.92, 0.97, 1.0, 0.92) if ScoreStore.is_light_theme() else Color(0.025, 0.035, 0.065, 0.92)
	var hover_fill: Color = Color(0.82, 0.93, 1.0, 0.96) if ScoreStore.is_light_theme() else Color(0.045, 0.065, 0.12, 0.96)
	var pressed_fill: Color = Color(0.74, 0.88, 0.98, 0.98) if ScoreStore.is_light_theme() else Color(0.018, 0.025, 0.05, 0.98)
	var disabled_fill: Color = Color(0.78, 0.82, 0.88, 0.92) if ScoreStore.is_light_theme() else Color(0.025, 0.03, 0.045)
	var font_color: Color = Color(0.03, 0.08, 0.14) if ScoreStore.is_light_theme() else Color(0.9, 0.96, 1.0)
	button.text = text
	button.custom_minimum_size = Vector2(310, 58)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.pressed.connect(callback)
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_stylebox_override("normal", _button_style(normal_fill, Color(0.0, 0.75, 1.0, 0.72), 14))
	button.add_theme_stylebox_override("hover", _button_style(hover_fill, Color(0.0, 1.0, 0.75, 0.92), 14))
	button.add_theme_stylebox_override("pressed", _button_style(pressed_fill, Color(1.0, 0.0, 0.75, 0.95), 14))
	button.add_theme_stylebox_override("disabled", _button_style(disabled_fill, Color(0.15, 0.16, 0.22, 0.8), 14))
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_disabled_color", Color(0.42, 0.48, 0.58))
	return button


func _make_icon_button(text: String, callback: Callable) -> Button:
	var button: Button = Button.new()
	var fill: Color = Color(0.92, 0.97, 1.0, 0.92) if ScoreStore.is_light_theme() else Color(0.012, 0.024, 0.046, 0.9)
	var hover_fill: Color = Color(0.82, 0.93, 1.0, 0.96) if ScoreStore.is_light_theme() else Color(0.025, 0.05, 0.09, 0.96)
	var pressed_fill: Color = Color(0.74, 0.88, 0.98, 0.98) if ScoreStore.is_light_theme() else Color(0.008, 0.018, 0.035, 0.98)
	var font_color: Color = Color(0.03, 0.08, 0.14) if ScoreStore.is_light_theme() else Color(0.92, 0.98, 1.0)
	button.text = text
	button.custom_minimum_size = Vector2(48, 48)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	button.pressed.connect(callback)
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_stylebox_override("normal", _button_style(fill, Color(0.0, 0.75, 1.0, 0.72), 12))
	button.add_theme_stylebox_override("hover", _button_style(hover_fill, Color(0.0, 1.0, 0.75, 0.92), 12))
	button.add_theme_stylebox_override("pressed", _button_style(pressed_fill, Color(1.0, 0.0, 0.75, 0.95), 12))
	button.add_theme_color_override("font_color", font_color)
	return button


func _make_label(text: String, size: int, color: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label


func _button_style(fill: Color, border: Color, radius: int = 18) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
	style.shadow_color = Color(border.r, border.g, border.b, 0.3)
	style.shadow_size = 14
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style


func _bar_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(border.r, border.g, border.b, 0.42)
	style.shadow_size = 10
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	return style


func _set_back_target(target: String) -> void:
	current_back_target = target
	if back_button != null:
		back_button.visible = target != ""


func _on_back_pressed() -> void:
	_handle_back_request()


func _handle_back_request() -> void:
	if screen_state == "game":
		if in_game_options != null and not in_game_options.visible:
			in_game_options.visible = true
		else:
			_show_menu()
		return

	if screen_state == "collection" or screen_state == "game_over":
		_show_menu()
		return

	if current_back_target == "menu":
		_show_menu()


func _set_game_chrome(in_game: bool) -> void:
	hud_panel.visible = in_game
	hud_reward_label.visible = false
	options_button.visible = in_game
	in_game_options.visible = false
	_update_mute_button()


func _update_hud() -> void:
	var xp_needed: int = ScoreStore.xp_to_next_survival_level()
	hud_record_label.text = "RECORDE %d" % ScoreStore.best_survival
	hud_points_label.text = "PONTOS %d" % score
	hud_level_label.text = "NIVEL %d" % ScoreStore.survival_level
	hud_xp_bar.max_value = xp_needed
	hud_xp_bar.value = clampi(ScoreStore.survival_xp, 0, xp_needed)
	hud_xp_label.text = "XP %d/%d   NIVEL %d -> %d" % [ScoreStore.survival_xp, xp_needed, ScoreStore.survival_level, ScoreStore.survival_level + 1]


func _toggle_options_panel() -> void:
	in_game_options.visible = not in_game_options.visible


func _toggle_audio() -> void:
	ScoreStore.set_audio_muted(not ScoreStore.audio_muted)
	_update_mute_button()


func _toggle_audio_from_settings() -> void:
	ScoreStore.set_audio_muted(not ScoreStore.audio_muted)
	_show_settings()


func _set_visual_theme(value: String) -> void:
	ScoreStore.set_visual_theme(value)
	_apply_unlocked_visuals()
	_show_settings()


func _update_mute_button() -> void:
	if mute_button != null:
		mute_button.text = "AUDIO: OFF" if ScoreStore.audio_muted else "AUDIO: ON"


func _show_success_feedback() -> void:
	board.call("show_feedback", "success")
	_play_tone(880.0, 0.12)


func _show_error_feedback() -> void:
	board.call("show_feedback", "error")
	_play_tone(130.0, 0.28)


func _play_pad_tone(index: int, duration: float) -> void:
	var frequencies: Array[float] = [392.0, 523.25, 659.25, 783.99]
	_play_tone(frequencies[index], duration)


func _play_tone(frequency: float, duration: float) -> void:
	if ScoreStore.audio_muted or audio_player == null:
		return
	audio_player.stop()
	audio_player.play()
	var playback: AudioStreamGeneratorPlayback = audio_player.get_stream_playback()
	if playback == null:
		return
	var mix_rate: float = 44100.0
	var frames: int = int(mix_rate * duration)
	for frame in range(frames):
		var t: float = float(frame) / mix_rate
		var fade: float = minf(1.0, float(frames - frame) / maxf(1.0, mix_rate * 0.04))
		var sample: float = sin(TAU * frequency * t) * 0.22 * fade
		playback.push_frame(Vector2(sample, sample))


func _flash_time_for_level() -> float:
	return clampf(0.48 - float(ScoreStore.survival_level - 1) * 0.012, 0.22, 0.5)


func _xp_for_score(current_score: int) -> int:
	return 10 + mini(current_score, 20)


func _unlock_due_rewards() -> Array[String]:
	var unlocked_names: Array[String] = []
	for reward in REWARDS:
		var id: String = String(reward["id"])
		var kind: String = String(reward["kind"])
		var required_level: int = int(reward["level"])
		if ScoreStore.survival_level >= required_level and ScoreStore.unlock_reward(id, kind):
			unlocked_names.append(String(reward["name"]))
	return unlocked_names


func _show_reward_notice(reward_names: Array[String], previous_level: int) -> void:
	if reward_names.size() > 0:
		hud_reward_label.text = "RECOMPENSA: %s" % _join_strings(reward_names)
		hud_reward_label.visible = true
	elif ScoreStore.survival_level > previous_level:
		hud_reward_label.text = "NOVO NIVEL: %d" % ScoreStore.survival_level
		hud_reward_label.visible = true
	else:
		hud_reward_label.visible = false


func _join_strings(items: Array[String]) -> String:
	var result: String = ""
	for index in range(items.size()):
		if index > 0:
			result += ", "
		result += items[index]
	return result


func _apply_unlocked_visuals() -> void:
	if background_layer != null and background_layer.has_method("set_theme_id"):
		background_layer.call("set_theme_id", ScoreStore.selected_background)
	if background_layer != null and background_layer.has_method("set_light_mode"):
		background_layer.call("set_light_mode", ScoreStore.is_light_theme())
	if board != null and board.has_method("set_style"):
		board.call("set_style", ScoreStore.selected_board_style)
	_apply_interface_theme()


func _apply_interface_theme() -> void:
	var panel_fill: Color = Color(0.92, 0.97, 1.0, 0.88) if ScoreStore.is_light_theme() else Color(0.006, 0.012, 0.026, 0.82)
	var panel_border: Color = Color(0.0, 0.46, 0.8, 0.66) if ScoreStore.is_light_theme() else Color(0.0, 0.78, 1.0, 0.72)
	var text_main: Color = Color(0.03, 0.08, 0.14) if ScoreStore.is_light_theme() else Color(0.96, 0.99, 1.0)
	var text_soft: Color = Color(0.12, 0.25, 0.38) if ScoreStore.is_light_theme() else Color(0.72, 0.9, 1.0)

	if hud_panel != null:
		hud_panel.add_theme_stylebox_override("panel", _button_style(panel_fill, panel_border, 12))
	if in_game_options != null:
		in_game_options.add_theme_stylebox_override("panel", _button_style(panel_fill, panel_border, 12))

	for label in [title_label, score_label, hud_points_label]:
		if label != null:
			label.add_theme_color_override("font_color", text_main)
	for label in [subtitle_label, status_label, hud_record_label, hud_xp_label]:
		if label != null:
			label.add_theme_color_override("font_color", text_soft)


func _set_menu_logo_visible(visible: bool) -> void:
	menu_logo.visible = visible
	menu_spacer.visible = false


func _achievement_count() -> int:
	var total: int = 0
	for achievement in ACHIEVEMENTS:
		if ScoreStore.is_achievement_unlocked(String(achievement["id"])):
			total += 1
	return total


func _check_achievements() -> void:
	for achievement in ACHIEVEMENTS:
		var id: String = String(achievement["id"])
		if ScoreStore.is_achievement_unlocked(id):
			continue
		if _achievement_requirement_met(achievement):
			ScoreStore.unlock_achievement(id)


func _achievement_requirement_met(achievement: Dictionary) -> bool:
	var type: String = String(achievement["type"])
	var value: int = int(achievement["value"])
	if type == "games":
		return ScoreStore.games_played >= value
	if type == "survival":
		return ScoreStore.best_survival >= value or score >= value
	if type == "level":
		return ScoreStore.survival_level >= value
	if type == "rewards":
		return ScoreStore.unlocked_reward_count() >= value
	return false


func _make_achievement_card(achievement: Dictionary) -> PanelContainer:
	var unlocked: bool = ScoreStore.is_achievement_unlocked(String(achievement["id"]))
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var border: Color = Color(1.0, 0.64, 0.0, 0.84) if unlocked else Color(0.0, 0.64, 1.0, 0.48)
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.018, 0.026, 0.048, 0.92), border, 12))
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)
	var title: Label = _make_label(("%s  // DESBLOQUEADA" if unlocked else "%s  // BLOQUEADA") % String(achievement["name"]), 16, Color(1.0, 0.86, 0.42) if unlocked else Color(0.72, 0.86, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	box.add_child(title)
	var requirement: Label = _make_label(String(achievement["requirement"]), 14, Color(0.82, 0.9, 1.0))
	requirement.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	requirement.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(requirement)
	return panel


func _make_reward_card(reward: Dictionary, selectable: bool) -> PanelContainer:
	var id: String = String(reward["id"])
	var kind: String = String(reward["kind"])
	var unlocked: bool = ScoreStore.is_reward_unlocked(id)
	var selected: bool = (kind == "background" and ScoreStore.selected_background == id) or (kind == "board" and ScoreStore.selected_board_style == id)
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var border: Color = Color(1.0, 0.78, 0.2, 0.82) if selected else (Color(0.0, 0.95, 0.78, 0.72) if unlocked else Color(0.22, 0.32, 0.48, 0.52))
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.014, 0.021, 0.04, 0.92), border, 12))
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)
	var suffix: String = " // EM USO" if selected else (" // LIBERADA" if unlocked else " // BLOQUEADA")
	var title: Label = _make_label("%s%s" % [String(reward["name"]), suffix], 16, Color(1.0, 0.86, 0.42) if selected else (Color(0.68, 1.0, 0.9) if unlocked else Color(0.64, 0.72, 0.86)))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	box.add_child(title)
	var requirement: Label = _make_label(String(reward["requirement"]), 14, Color(0.82, 0.9, 1.0))
	requirement.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	requirement.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(requirement)
	if selectable:
		var button: Button = _make_button("USAR" if unlocked else "BLOQUEADO", Callable(self, "_select_reward").bind(id, kind))
		button.disabled = not unlocked
		box.add_child(button)
	return panel


func _select_reward(id: String, kind: String) -> void:
	ScoreStore.select_reward(id, kind)
	_apply_unlocked_visuals()
	_show_customization()


func _make_section_label(text: String) -> Label:
	var label: Label = _make_label(text, 15, Color(1.0, 0.72, 0.24))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	return label


func _queue_responsive_layout() -> void:
	if responsive_layout_queued:
		return
	responsive_layout_queued = true
	call_deferred("_apply_responsive_layout")


func _safe_insets(viewport_size: Vector2) -> Vector4:
	var safe_area: Rect2i = DisplayServer.get_display_safe_area()
	if safe_area.size.x <= 0 or safe_area.size.y <= 0:
		return Vector4.ZERO

	var safe_position: Vector2 = Vector2(safe_area.position)
	var safe_size: Vector2 = Vector2(safe_area.size)
	if safe_size.x > viewport_size.x * 1.2 or safe_size.y > viewport_size.y * 1.2:
		var window_size: Vector2 = Vector2(DisplayServer.window_get_size())
		if window_size.x > 0.0 and window_size.y > 0.0:
			var scale: Vector2 = Vector2(viewport_size.x / window_size.x, viewport_size.y / window_size.y)
			safe_position *= scale
			safe_size *= scale

	var left: float = clampf(safe_position.x, 0.0, viewport_size.x * 0.35)
	var top: float = clampf(safe_position.y, 0.0, viewport_size.y * 0.25)
	var right: float = clampf(viewport_size.x - (safe_position.x + safe_size.x), 0.0, viewport_size.x * 0.35)
	var bottom: float = clampf(viewport_size.y - (safe_position.y + safe_size.y), 0.0, viewport_size.y * 0.25)
	return Vector4(left, top, right, bottom)


func _apply_responsive_layout() -> void:
	responsive_layout_queued = false
	if root_box == null:
		return
	var viewport_size: Vector2 = size
	if viewport_size.x <= 1.0 or viewport_size.y <= 1.0:
		viewport_size = get_viewport_rect().size
	var shortest: float = minf(viewport_size.x, viewport_size.y)
	var landscape: bool = viewport_size.x > viewport_size.y
	var wide: bool = viewport_size.x >= 900.0
	var compact: bool = shortest < 430.0
	var safe_insets: Vector4 = _safe_insets(viewport_size)
	var horizontal_margin: int = int(clampf(viewport_size.x * 0.04, 12.0, 70.0))
	var vertical_margin: int = int(clampf(viewport_size.y * 0.022, 10.0, 34.0))
	var gameplay_layout: bool = screen_state == "game" or screen_state == "game_over"
	var gameplay_hud_height: float = clampf(shortest * 0.205, 82.0, 96.0)
	var gameplay_hud_y: float = maxf(safe_insets.y + 12.0, viewport_size.y * (0.038 if compact else 0.045))
	var gameplay_top_margin: float = gameplay_hud_y + gameplay_hud_height + clampf(shortest * 0.035, 12.0, 20.0)
	main_margin.add_theme_constant_override("margin_left", horizontal_margin)
	main_margin.add_theme_constant_override("margin_right", horizontal_margin)
	main_margin.add_theme_constant_override("margin_top", int(maxf(float(vertical_margin), gameplay_top_margin if gameplay_layout else safe_insets.y + 10.0)))
	main_margin.add_theme_constant_override("margin_bottom", int(maxf(float(vertical_margin), safe_insets.w + 10.0)))

	var max_width: float = 760.0 if wide else (680.0 if landscape else 540.0)
	var root_width: float = minf(viewport_size.x - float(horizontal_margin * 2), max_width)
	root_box.custom_minimum_size = Vector2(root_width, 0.0)
	if screen_state == "game_over":
		content_box.custom_minimum_size = Vector2(root_width, maxf(320.0, viewport_size.y - safe_insets.y - safe_insets.w - 170.0))
	else:
		content_box.custom_minimum_size = Vector2(root_width, 0.0)
	root_box.add_theme_constant_override("separation", int(10 if compact else 14))
	action_row.add_theme_constant_override("separation", int(10 if compact else 12))
	content_box.add_theme_constant_override("separation", int(10 if compact else 12))

	var low_height: bool = viewport_size.y < 760.0
	var title_size: int = int(clampf(shortest * 0.07, 26.0, 48.0))
	var subtitle_size: int = int(clampf(shortest * 0.032, 12.0, 18.0))
	var body_size: int = int(clampf(shortest * 0.037, 14.0, 20.0))
	var button_font_size: int = int(clampf(shortest * 0.042, 15.0, 20.0))
	var logo_size: int = int(clampf(shortest * 0.25, 96.0, 176.0))
	if low_height:
		title_size = maxi(title_size - 4, 24)
		body_size = maxi(body_size - 2, 13)
		button_font_size = maxi(button_font_size - 1, 14)
		logo_size = maxi(logo_size - 10, 88)
	_set_label_font(title_label, title_size)
	_set_label_font(subtitle_label, subtitle_size)
	_set_label_font(score_label, body_size)
	_set_label_font(status_label, body_size)
	menu_logo.custom_minimum_size = Vector2(root_box.custom_minimum_size.x, clampf(float(logo_size) * 1.28, 128.0, 232.0))

	var board_limit_by_width: float = minf(viewport_size.x - float(horizontal_margin * 2), root_box.custom_minimum_size.x * 1.22)
	var available_game_height: float = viewport_size.y - gameplay_top_margin - safe_insets.w - float(vertical_margin)
	var board_limit_by_height: float = available_game_height * (0.98 if gameplay_layout else (0.54 if landscape else 0.62))
	var board_min: float = 340.0 if low_height else 410.0
	var board_max: float = 610.0 if not wide else 740.0
	if compact:
		board_min = 320.0
	var board_size: float = clampf(minf(board_limit_by_width, board_limit_by_height), board_min, board_max)
	board.custom_minimum_size = Vector2(board_size, board_size)

	var button_width: float = minf(root_box.custom_minimum_size.x, 560.0 if wide else 450.0)
	var button_height: float = clampf(shortest * (0.125 if low_height else 0.145), 56.0, 82.0)
	_apply_button_metrics(content_box, button_width, button_height, button_font_size)
	_apply_button_metrics(action_row, button_width, button_height, button_font_size)
	if back_button != null:
		var back_size: float = clampf(shortest * 0.115, 44.0, 58.0)
		back_button.custom_minimum_size = Vector2(back_size, back_size)
		back_button.add_theme_font_size_override("font_size", int(clampf(back_size * 0.38, 17.0, 22.0)))
		top_spacer.custom_minimum_size = back_button.custom_minimum_size
	if options_button != null:
		var icon_size: float = clampf(shortest * 0.13, 50.0, 62.0)
		options_button.custom_minimum_size = Vector2(icon_size, icon_size)
		options_button.position = Vector2(maxf(horizontal_margin * 0.55, safe_insets.x + 10.0), maxf(vertical_margin * 0.65, safe_insets.y + 8.0))
		options_button.add_theme_font_size_override("font_size", int(clampf(icon_size * 0.34, 16.0, 22.0)))
	if in_game_options != null:
		in_game_options.position = Vector2(options_button.position.x, options_button.position.y + options_button.custom_minimum_size.y + 10.0)
		_apply_button_metrics(in_game_options, clampf(shortest * 0.42, 156.0, 196.0), clampf(shortest * 0.112, 46.0, 54.0), int(clampf(shortest * 0.034, 13.0, 15.0)))
	if hud_panel != null:
		var hud_width: float = clampf(viewport_size.x * 0.62, 330.0, 460.0)
		if viewport_size.x < 520.0:
			hud_width = clampf(viewport_size.x - 92.0, 268.0, 360.0)
		hud_panel.custom_minimum_size = Vector2(hud_width, gameplay_hud_height)
		hud_panel.size = hud_panel.custom_minimum_size
		hud_panel.position = Vector2((viewport_size.x - hud_width) * 0.5, gameplay_hud_y)
		hud_xp_bar.custom_minimum_size = Vector2(maxf(220.0, hud_width - 42.0), clampf(shortest * 0.03, 11.0, 14.0))
		_set_label_font(hud_record_label, int(clampf(shortest * 0.03, 11.0, 14.0)))
		_set_label_font(hud_points_label, int(clampf(shortest * 0.038, 14.0, 18.0)))
		_set_label_font(hud_level_label, int(clampf(shortest * 0.03, 11.0, 14.0)))
		_set_label_font(hud_xp_label, int(clampf(shortest * 0.029, 11.0, 13.0)))
	if hud_reward_label != null:
		hud_reward_label.position = Vector2((viewport_size.x - minf(root_box.custom_minimum_size.x, 480.0)) * 0.5, hud_panel.position.y + hud_panel.custom_minimum_size.y + 8.0)


func _set_label_font(label: Label, font_size: int) -> void:
	if label != null:
		label.add_theme_font_size_override("font_size", font_size)


func _apply_button_metrics(node: Node, button_width: float, button_height: float, font_size: int) -> void:
	if node == null:
		return
	for child in node.get_children():
		if child is Button:
			var button: Button = child as Button
			if button == back_button:
				continue
			button.custom_minimum_size = Vector2(button_width, button_height)
			button.add_theme_font_size_override("font_size", font_size)
		_apply_button_metrics(child, button_width, button_height, font_size)
