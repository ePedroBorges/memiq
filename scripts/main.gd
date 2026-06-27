extends Control

const SPLASH_SECONDS: float = 2.2
const ACHIEVEMENTS: Array[Dictionary] = [
	{"id": "first_signal", "name": "Primeiro Sinal", "requirement": "Jogue uma partida.", "type": "games", "value": 1},
	{"id": "infinite_10", "name": "Infinito I", "requirement": "Alcance 10 pontos no modo Infinito.", "type": "survival", "value": 10},
	{"id": "infinite_25", "name": "Fluxo Infinito", "requirement": "Alcance 25 pontos no modo Infinito.", "type": "survival", "value": 25},
	{"id": "infinite_50", "name": "Sem Ruido", "requirement": "Alcance 50 pontos no modo Infinito.", "type": "survival", "value": 50},
	{"id": "phase_5", "name": "Setor 05", "requirement": "Chegue a fase 5 no modo Aventura.", "type": "adventure_phase", "value": 5},
	{"id": "phase_10", "name": "Setor 10", "requirement": "Chegue a fase 10 no modo Aventura.", "type": "adventure_phase", "value": 10},
	{"id": "phase_25", "name": "Mapa Expandido", "requirement": "Chegue a fase 25 no modo Aventura.", "type": "adventure_phase", "value": 25},
	{"id": "level_2", "name": "Nivel 2", "requirement": "Suba para o nivel 2 no modo Aventura.", "type": "adventure_level", "value": 2},
	{"id": "level_5", "name": "Operador Neon", "requirement": "Suba para o nivel 5 no modo Aventura.", "type": "adventure_level", "value": 5},
	{"id": "level_10", "name": "Arquiteto RGB", "requirement": "Suba para o nivel 10 no modo Aventura.", "type": "adventure_level", "value": 10},
	{"id": "rewards_3", "name": "Colecionador", "requirement": "Desbloqueie 3 recompensas.", "type": "rewards", "value": 3},
	{"id": "rewards_6", "name": "Inventario Premium", "requirement": "Desbloqueie 6 recompensas.", "type": "rewards", "value": 6},
	{"id": "games_10", "name": "Rotina de Treino", "requirement": "Jogue 10 partidas.", "type": "games", "value": 10},
]
const REWARDS: Array[Dictionary] = [
	{"id": "bg_neon", "kind": "background", "name": "Fundo Neon Grid", "requirement": "Inicial", "level": 1},
	{"id": "board_classic", "kind": "board", "name": "Genius Classico RGB", "requirement": "Inicial", "level": 1},
	{"id": "bg_aurora", "kind": "background", "name": "Fundo Aurora", "requirement": "Alcance o nivel 2", "level": 2},
	{"id": "board_plasma", "kind": "board", "name": "Genius Plasma", "requirement": "Alcance o nivel 3", "level": 3},
	{"id": "bg_sunset", "kind": "background", "name": "Fundo Sunset", "requirement": "Alcance o nivel 4", "level": 4},
	{"id": "board_solar", "kind": "board", "name": "Genius Solar", "requirement": "Alcance o nivel 5", "level": 5},
	{"id": "bg_void", "kind": "background", "name": "Fundo Void", "requirement": "Alcance o nivel 7", "level": 7},
	{"id": "board_void", "kind": "board", "name": "Genius Void", "requirement": "Alcance o nivel 8", "level": 8},
]

var mode: String = ""
var level: int = 1
var target_score: int = 0
var flash_time: float = 0.48
var sequence: Array[int] = []
var input_index: int = 0
var score: int = 0
var adventure_phase: int = 1
var phases_cleared_this_run: int = 0
var accepting_input: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var session_id: int = 0

var root_box: VBoxContainer
var title_label: Label
var subtitle_label: Label
var status_label: Label
var score_label: Label
var board: Control
var top_bar: HBoxContainer
var action_row: VBoxContainer
var content_box: VBoxContainer
var content_scroll: ScrollContainer
var back_button: Button
var main_margin: MarginContainer
var top_spacer: Control
var menu_logo: Control
var menu_spacer: Control
var hud_best_label: Label
var hud_reward_label: Label
var background_layer: Control
var splash_layer: CanvasLayer
var splash_root: Control
var current_back_target: String = "menu"
var responsive_layout_queued: bool = false


func _ready() -> void:
	rng.randomize()
	_build_ui()
	resized.connect(_queue_responsive_layout)
	if get_viewport().has_signal("size_changed"):
		get_viewport().connect("size_changed", Callable(self, "_queue_responsive_layout"))
	if get_tree().root.has_signal("size_changed"):
		get_tree().root.connect("size_changed", Callable(self, "_queue_responsive_layout"))
	call_deferred("_apply_responsive_layout")
	_show_splash()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_queue_responsive_layout()


func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	background_layer = preload("res://scripts/neon_background.gd").new()
	background_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background_layer)

	main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_margin.add_theme_constant_override("margin_left", 22)
	main_margin.add_theme_constant_override("margin_right", 22)
	main_margin.add_theme_constant_override("margin_top", 18)
	main_margin.add_theme_constant_override("margin_bottom", 22)
	add_child(main_margin)

	var horizontal_shell: HBoxContainer = HBoxContainer.new()
	horizontal_shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	horizontal_shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	horizontal_shell.alignment = BoxContainer.ALIGNMENT_CENTER
	main_margin.add_child(horizontal_shell)

	var left_spacer: Control = Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	horizontal_shell.add_child(left_spacer)

	root_box = VBoxContainer.new()
	root_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	root_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	root_box.add_theme_constant_override("separation", 12)
	horizontal_shell.add_child(root_box)

	var right_spacer: Control = Control.new()
	right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	horizontal_shell.add_child(right_spacer)

	top_bar = HBoxContainer.new()
	top_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	top_bar.add_theme_constant_override("separation", 8)
	root_box.add_child(top_bar)

	back_button = _make_button("<", _on_back_pressed)
	back_button.custom_minimum_size = Vector2(54, 44)
	back_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	back_button.visible = false
	top_bar.add_child(back_button)

	var title_area: VBoxContainer = VBoxContainer.new()
	title_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_area.alignment = BoxContainer.ALIGNMENT_CENTER
	title_area.add_theme_constant_override("separation", 2)
	top_bar.add_child(title_area)

	title_label = _make_label("MEMIQ", 38, Color(0.94, 0.98, 1.0))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_area.add_child(title_label)

	subtitle_label = _make_label("", 16, Color(0.66, 0.76, 0.9))
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_area.add_child(subtitle_label)

	top_spacer = Control.new()
	top_spacer.custom_minimum_size = Vector2(54, 44)
	top_spacer.size_flags_horizontal = Control.SIZE_SHRINK_END
	top_bar.add_child(top_spacer)

	score_label = _make_label("", 18, Color(0.9, 0.96, 1.0))
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root_box.add_child(score_label)

	board = preload("res://scripts/genius_board.gd").new()
	board.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	board.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	board.custom_minimum_size = Vector2(318, 318)
	board.pad_pressed.connect(_on_pad_pressed)
	root_box.add_child(board)

	status_label = _make_label("", 18, Color(0.82, 0.9, 1.0))
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root_box.add_child(status_label)

	content_scroll = ScrollContainer.new()
	content_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_scroll.follow_focus = true
	root_box.add_child(content_scroll)

	content_box = VBoxContainer.new()
	content_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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

	menu_logo = preload("res://scripts/memiq_logo.gd").new()
	menu_logo.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_child(menu_logo)
	root_box.move_child(menu_logo, 1)
	root_box.move_child(menu_spacer, 5)

	hud_best_label = _make_label("", 16, Color(0.86, 0.96, 1.0))
	hud_best_label.position = Vector2(18, 14)
	hud_best_label.visible = false
	add_child(hud_best_label)

	hud_reward_label = _make_label("", 15, Color(1.0, 0.78, 0.28))
	hud_reward_label.position = Vector2(18, 54)
	hud_reward_label.visible = false
	add_child(hud_reward_label)

	root_box.visible = false
	_apply_unlocked_visuals()
	_apply_responsive_layout()


func _show_splash() -> void:
	splash_layer = CanvasLayer.new()
	splash_layer.layer = 20
	add_child(splash_layer)

	splash_root = Control.new()
	splash_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_layer.add_child(splash_root)

	var splash_background: ColorRect = ColorRect.new()
	splash_background.color = Color(0.0, 0.0, 0.0, 1.0)
	splash_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_root.add_child(splash_background)

	var safe_margin: MarginContainer = MarginContainer.new()
	safe_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	safe_margin.add_theme_constant_override("margin_left", 28)
	safe_margin.add_theme_constant_override("margin_right", 28)
	safe_margin.add_theme_constant_override("margin_top", 48)
	safe_margin.add_theme_constant_override("margin_bottom", 48)
	splash_root.add_child(safe_margin)

	var logo: TextureRect = TextureRect.new()
	logo.texture = _load_png_texture("res://assets/anchorlab.png")
	logo.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	logo.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe_margin.add_child(logo)

	await get_tree().create_timer(SPLASH_SECONDS).timeout

	var tween: Tween = create_tween()
	tween.tween_property(splash_root, "modulate:a", 0.0, 0.35)
	await tween.finished

	splash_layer.queue_free()
	root_box.visible = true
	_show_menu()


func _load_png_texture(path: String) -> Texture2D:
	var image: Image = Image.new()
	var error: int = image.load(path)
	if error != OK:
		push_error("Nao foi possivel carregar a imagem: %s" % path)
		return null

	return ImageTexture.create_from_image(image)


func _show_menu() -> void:
	session_id += 1
	_clear_boxes()
	_set_back_target("")
	if top_bar != null:
		top_bar.visible = false
	root_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	mode = ""
	_set_game_chrome(false)
	_set_menu_logo_visible(true)
	if content_scroll != null:
		content_scroll.visible = false
	action_row.visible = true
	board.visible = false
	board.enabled = false
	title_label.visible = false
	subtitle_label.visible = false
	score_label.visible = false
	status_label.visible = false

	action_row.add_child(_make_button("AVENTURA", _start_adventure))
	action_row.add_child(_make_button("INFINITO", _start_survival))
	action_row.add_child(_make_button("CONQUISTAS  %d/%d" % [_achievement_count(), ACHIEVEMENTS.size()], _show_achievements))
	_apply_responsive_layout()


func _show_achievements() -> void:
	session_id += 1
	_clear_boxes()
	_set_back_target("menu")
	_set_game_chrome(false)
	_set_menu_logo_visible(false)
	if content_scroll != null:
		content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.alignment = BoxContainer.ALIGNMENT_CENTER
	if top_bar != null:
		top_bar.visible = true

	root_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	board.visible = false
	title_label.visible = true
	subtitle_label.visible = true
	score_label.visible = false
	status_label.visible = true
	title_label.text = "CONQUISTAS"
	subtitle_label.text = "%d/%d desbloqueadas" % [_achievement_count(), ACHIEVEMENTS.size()]
	status_label.text = "Veja seus objetivos e requisitos."

	for achievement in ACHIEVEMENTS:
		content_box.add_child(_make_achievement_card(achievement))

	content_box.add_child(_make_section_label("RECOMPENSAS"))
	for reward in REWARDS:
		content_box.add_child(_make_reward_card(reward))

	_apply_responsive_layout()


func _start_survival() -> void:
	mode = "survival"
	level = 1
	target_score = 0
	flash_time = 0.46
	_start_game()


func _start_adventure() -> void:
	mode = "adventure"
	level = ScoreStore.adventure_level
	adventure_phase = ScoreStore.adventure_phase
	_start_game()


func _start_game() -> void:
	session_id += 1
	var current_session: int = session_id
	_clear_boxes()
	_set_back_target("menu")
	_set_game_chrome(true)
	_set_menu_logo_visible(false)
	if content_scroll != null:
		content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.alignment = BoxContainer.ALIGNMENT_CENTER
	if top_bar != null:
		top_bar.visible = false
	board.visible = true
	board.custom_minimum_size = Vector2(340, 340)
	title_label.visible = false
	subtitle_label.visible = false
	score_label.visible = false
	status_label.visible = false
	sequence.clear()
	score = 0
	phases_cleared_this_run = 0
	input_index = 0
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
	if mode == "adventure":
		_prepare_adventure_phase()
	else:
		sequence.append(rng.randi_range(0, 3))
	_update_score_label()

	await get_tree().create_timer(0.35).timeout
	if current_session != session_id:
		return

	for color_index in sequence:
		await board.flash_pad(color_index, flash_time)
		if current_session != session_id:
			return
		await get_tree().create_timer(max(0.08, flash_time * 0.34)).timeout
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
	await board.flash_pad(index, 0.22)
	if current_session != session_id:
		return

	if sequence[input_index] != index:
		_finish_game(false)
		return

	input_index += 1
	if input_index >= sequence.size():
		score += 1
		if mode == "survival":
			flash_time = max(0.22, flash_time - 0.012)
		elif mode == "adventure":
			_complete_adventure_phase()

		await get_tree().create_timer(0.42).timeout
		if current_session == session_id:
			_next_round(current_session)
	else:
		accepting_input = true
		board.enabled = true

	_update_score_label()
	_update_hud()


func _finish_game(_won: bool) -> void:
	session_id += 1
	accepting_input = false
	board.enabled = false
	_clear_boxes()
	_set_back_target("menu")
	board.visible = false
	root_box.alignment = BoxContainer.ALIGNMENT_CENTER

	var new_record: bool = false
	if mode == "survival":
		new_record = ScoreStore.record_survival(score)
	else:
		ScoreStore.record_adventure_run_finished(phases_cleared_this_run)

	_check_achievements()

	_update_score_label()
	_update_hud()
	_set_game_chrome(false)
	if top_bar != null:
		top_bar.visible = true
	title_label.visible = true
	subtitle_label.visible = true
	status_label.visible = true
	title_label.text = "NOVO RECORDE" if new_record else "FIM DE JOGO"
	if mode == "survival":
		subtitle_label.text = "Pontuacao: %d" % score
		status_label.text = "Recorde do Infinito: %d" % ScoreStore.best_survival
	else:
		subtitle_label.text = "Fases concluidas: %d" % phases_cleared_this_run
		status_label.text = "Fase atual: %d   Nivel: %d" % [ScoreStore.adventure_phase, ScoreStore.adventure_level]
	var replay_callback: Callable = Callable(self, "_start_adventure") if mode == "adventure" else Callable(self, "_start_survival")
	content_box.add_child(_make_button("JOGAR NOVAMENTE", replay_callback))
	content_box.add_child(_make_button("MENU", _show_menu))
	_apply_responsive_layout()


func _update_score_label() -> void:
	if mode == "survival":
		score_label.text = "Pontuacao: %d" % score
	elif mode == "adventure":
		score_label.text = "Fase %d   Nivel %d" % [adventure_phase, level]
	else:
		score_label.text = ""


func _clear_boxes() -> void:
	if content_box == null or action_row == null:
		return

	for child in content_box.get_children():
		child.queue_free()
	for child in action_row.get_children():
		child.queue_free()


func _make_button(text: String, callback: Callable) -> Button:
	var button: Button = Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(310, 58)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.pressed.connect(callback)
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_stylebox_override("normal", _button_style(Color(0.025, 0.035, 0.065, 0.92), Color(0.0, 0.75, 1.0, 0.72), 22))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.045, 0.065, 0.12, 0.96), Color(0.0, 1.0, 0.75, 0.92), 22))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.018, 0.025, 0.05, 0.98), Color(1.0, 0.0, 0.75, 0.95), 22))
	button.add_theme_stylebox_override("disabled", _button_style(Color(0.025, 0.03, 0.045), Color(0.15, 0.16, 0.22, 0.8), 22))
	button.add_theme_color_override("font_color", Color(0.9, 0.96, 1.0))
	button.add_theme_color_override("font_disabled_color", Color(0.42, 0.48, 0.58))
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
	style.shadow_color = Color(border.r, border.g, border.b, 0.34)
	style.shadow_size = 16
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style


func _set_back_target(target: String) -> void:
	current_back_target = target
	if back_button != null:
		back_button.visible = target != ""


func _on_back_pressed() -> void:
	if current_back_target == "menu":
		_show_menu()


func _set_game_chrome(in_game: bool) -> void:
	if hud_best_label != null:
		hud_best_label.visible = in_game

	if hud_reward_label != null:
		hud_reward_label.visible = false

	if content_scroll != null:
		content_scroll.visible = not in_game

	if action_row != null:
		action_row.visible = not in_game


func _update_hud() -> void:
	if hud_best_label == null:
		return

	if mode == "survival":
		hud_best_label.text = "RECORDE: %d\nPONTOS: %d" % [ScoreStore.best_survival, score]
	elif mode == "adventure":
		hud_best_label.text = "FASE %02d\nNIVEL %d  XP %d/%d" % [adventure_phase, level, ScoreStore.adventure_xp, ScoreStore.xp_to_next_level(level)]
	else:
		hud_best_label.text = ""


func _prepare_adventure_phase() -> void:
	sequence.clear()
	var length: int = _adventure_sequence_length(adventure_phase, level)
	for _item in range(length):
		sequence.append(rng.randi_range(0, 3))

	flash_time = clampf(0.56 - float(level) * 0.014 - float(adventure_phase) * 0.002 + rng.randf_range(-0.035, 0.025), 0.23, 0.58)


func _complete_adventure_phase() -> void:
	var cleared_phase: int = adventure_phase
	var xp_gain: int = _adventure_xp_for_phase(cleared_phase)
	var previous_level: int = ScoreStore.adventure_level
	phases_cleared_this_run += 1
	ScoreStore.record_adventure_phase_clear(cleared_phase, xp_gain)
	level = ScoreStore.adventure_level
	adventure_phase = ScoreStore.adventure_phase

	var reward_names: Array[String] = _unlock_due_rewards()
	_apply_unlocked_visuals()
	_check_achievements()

	if hud_reward_label != null:
		if reward_names.size() > 0:
			hud_reward_label.text = "RECOMPENSA: %s" % _join_strings(reward_names)
			hud_reward_label.visible = true
		elif level > previous_level:
			hud_reward_label.text = "NOVO NIVEL: %d" % level
			hud_reward_label.visible = true
		else:
			hud_reward_label.visible = false

	_update_hud()


func _adventure_sequence_length(current_phase: int, current_level: int) -> int:
	return clampi(2 + int(current_phase / 2) + int(current_level / 3), 2, 14)


func _adventure_xp_for_phase(current_phase: int) -> int:
	return 12 + mini(current_phase * 2, 32)


func _unlock_due_rewards() -> Array[String]:
	var unlocked_names: Array[String] = []
	for reward in REWARDS:
		var id: String = String(reward["id"])
		var kind: String = String(reward["kind"])
		var required_level: int = int(reward["level"])
		if level >= required_level and ScoreStore.unlock_reward(id, kind):
			unlocked_names.append(String(reward["name"]))

	return unlocked_names


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

	if board != null and board.has_method("set_style"):
		board.call("set_style", ScoreStore.selected_board_style)


func _set_menu_logo_visible(visible: bool) -> void:
	if menu_logo != null:
		menu_logo.visible = visible

	if menu_spacer != null:
		menu_spacer.visible = visible


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
		return ScoreStore.best_survival >= value
	if type == "adventure_phase":
		return ScoreStore.best_adventure_phase >= value
	if type == "adventure_level":
		return ScoreStore.best_adventure_level >= value
	if type == "rewards":
		return ScoreStore.unlocked_reward_count() >= value

	return false


func _make_achievement_card(achievement: Dictionary) -> PanelContainer:
	var unlocked: bool = ScoreStore.is_achievement_unlocked(String(achievement["id"]))
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var border: Color = Color(1.0, 0.64, 0.0, 0.84) if unlocked else Color(0.0, 0.64, 1.0, 0.48)
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.018, 0.026, 0.048, 0.92), border, 20))

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


func _make_reward_card(reward: Dictionary) -> PanelContainer:
	var unlocked: bool = ScoreStore.is_reward_unlocked(String(reward["id"]))
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var border: Color = Color(0.0, 0.95, 0.78, 0.72) if unlocked else Color(0.22, 0.32, 0.48, 0.52)
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.014, 0.021, 0.04, 0.92), border, 20))

	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)
	panel.add_child(box)

	var title: Label = _make_label(("%s  // LIBERADA" if unlocked else "%s  // BLOQUEADA") % String(reward["name"]), 16, Color(0.68, 1.0, 0.9) if unlocked else Color(0.64, 0.72, 0.86))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	box.add_child(title)

	var requirement: Label = _make_label(String(reward["requirement"]), 14, Color(0.82, 0.9, 1.0))
	requirement.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	requirement.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(requirement)

	return panel


func _make_section_label(text: String) -> Label:
	var label: Label = _make_label(text, 15, Color(1.0, 0.72, 0.24))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.add_theme_constant_override("margin_top", 8)
	return label


func _make_stat_card(label_text: String, value_text: String) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.018, 0.026, 0.048, 0.9), Color(0.0, 0.64, 1.0, 0.55), 20))

	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	panel.add_child(row)

	var left: Label = _make_label(label_text, 16, Color(0.58, 0.85, 1.0))
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	row.add_child(left)

	var right: Label = _make_label(value_text, 18, Color(0.95, 0.98, 1.0))
	right.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(right)

	return panel


func _queue_responsive_layout() -> void:
	if responsive_layout_queued:
		return

	responsive_layout_queued = true
	call_deferred("_apply_responsive_layout")


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

	var horizontal_margin: int = int(clampf(viewport_size.x * 0.045, 14.0, 70.0))
	var vertical_margin: int = int(clampf(viewport_size.y * 0.018, 8.0, 28.0))
	if main_margin != null:
		main_margin.add_theme_constant_override("margin_left", horizontal_margin)
		main_margin.add_theme_constant_override("margin_right", horizontal_margin)
		main_margin.add_theme_constant_override("margin_top", vertical_margin)
		main_margin.add_theme_constant_override("margin_bottom", vertical_margin)

	var max_width: float = 520.0
	if wide:
		max_width = 760.0
	elif landscape:
		max_width = 680.0

	var root_width: float = minf(viewport_size.x - float(horizontal_margin * 2), max_width)
	root_box.custom_minimum_size = Vector2(root_width, 0.0)
	root_box.add_theme_constant_override("separation", int(8 if compact else 12))

	var low_height: bool = viewport_size.y < 760.0
	var title_size: int = int(clampf(shortest * 0.07, 26.0, 48.0))
	var subtitle_size: int = int(clampf(shortest * 0.032, 12.0, 18.0))
	var body_size: int = int(clampf(shortest * 0.037, 14.0, 20.0))
	var button_font_size: int = int(clampf(shortest * 0.038, 14.0, 19.0))
	var logo_size: int = int(clampf(shortest * 0.16, 54.0, 116.0))
	if low_height:
		title_size = int(maxi(title_size - 4, 24))
		body_size = int(maxi(body_size - 2, 13))
		button_font_size = int(maxi(button_font_size - 1, 13))
		logo_size = int(maxi(logo_size - 12, 46))
	_set_label_font(title_label, title_size)
	_set_label_font(subtitle_label, subtitle_size)
	_set_label_font(score_label, body_size)
	_set_label_font(status_label, body_size)
	if menu_logo != null:
		menu_logo.custom_minimum_size = Vector2(root_box.custom_minimum_size.x, clampf(float(logo_size) * 1.25, 76.0, 142.0))

	if back_button != null:
		var back_size: float = clampf(shortest * 0.115, 44.0, 58.0)
		back_button.custom_minimum_size = Vector2(back_size, back_size)
		back_button.add_theme_font_size_override("font_size", button_font_size)

	if top_spacer != null and back_button != null:
		top_spacer.custom_minimum_size = back_button.custom_minimum_size

	if board != null:
		var board_limit_by_width: float = minf(root_box.custom_minimum_size.x, viewport_size.x - float(horizontal_margin * 2)) * (0.96 if mode == "" else 1.02)
		var board_limit_by_height: float = viewport_size.y * (0.34 if low_height else (0.46 if landscape else 0.48))
		var board_size: float = minf(board_limit_by_width, board_limit_by_height)
		if mode == "":
			board_size = clampf(board_size, 170.0 if low_height else 210.0, 300.0 if low_height else (360.0 if not wide else 430.0))
		else:
			board_size = clampf(board_size, 260.0 if low_height else 340.0, 430.0 if not wide else 620.0)
		if compact:
			board_size = minf(board_size, 360.0 if mode != "" else 270.0)
		board.custom_minimum_size = Vector2(board_size, board_size)

	var button_width: float = minf(root_box.custom_minimum_size.x, 560.0 if wide else 430.0)
	var button_height: float = clampf(shortest * (0.11 if low_height else 0.135), 50.0, 78.0)
	_apply_button_metrics(content_box, button_width, button_height, button_font_size)
	_apply_button_metrics(action_row, button_width, button_height, button_font_size)


func _set_label_font(label: Label, font_size: int) -> void:
	if label == null:
		return

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
