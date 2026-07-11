extends Control

const SPLASH_SECONDS: float = 2.2
const OWNER_EMAIL: String = "pedroborges906@gmail.com"
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
	{"id": "phase_first", "name": "Primeira Fase", "requirement": "Conclua sua primeira fase.", "type": "phases", "value": 1},
	{"id": "phases_10", "name": "Explorador da Temporada", "requirement": "Conclua 10 fases.", "type": "phases", "value": 10},
	{"id": "phases_20", "name": "Memoria em Progresso", "requirement": "Conclua 20 fases.", "type": "phases", "value": 20},
	{"id": "phases_40", "name": "Mestre da Temporada", "requirement": "Conclua 40 fases.", "type": "phases", "value": 40},
	{"id": "wealth_1000", "name": "Cofre Neon", "requirement": "Junte 1.000 moedas de ouro.", "type": "gold", "value": 1000},
	{"id": "games_50", "name": "Ritmo Imparável", "requirement": "Jogue 50 partidas.", "type": "games", "value": 50},
	{"id": "games_100", "name": "Veterano MEMIQ", "requirement": "Jogue 100 partidas.", "type": "games", "value": 100},
	{"id": "phases_5", "name": "Primeiro Setor", "requirement": "Conclua 5 fases.", "type": "phases", "value": 5},
	{"id": "phases_30", "name": "Reta Final", "requirement": "Conclua 30 fases.", "type": "phases", "value": 30},
	{"id": "level_15", "name": "Mente Elétrica", "requirement": "Suba para o nível 15.", "type": "level", "value": 15},
	{"id": "level_30", "name": "Ícone da Memória", "requirement": "Suba para o nível 30.", "type": "level", "value": 30},
	{"id": "wealth_250", "name": "Primeiras Economias", "requirement": "Junte 250 moedas de ouro.", "type": "gold", "value": 250},
]
const ACHIEVEMENT_REWARDS: Dictionary = {
	"first_signal": {"gold": 75, "diamonds": 0},
	"games_10": {"gold": 150, "diamonds": 5},
	"games_25": {"gold": 250, "diamonds": 10},
	"games_50": {"gold": 400, "diamonds": 15},
	"games_100": {"gold": 750, "diamonds": 30},
	"infinite_10": {"gold": 120, "diamonds": 5},
	"infinite_25": {"gold": 300, "diamonds": 12},
	"infinite_50": {"gold": 600, "diamonds": 25},
	"infinite_100": {"gold": 1200, "diamonds": 60},
	"phase_first": {"gold": 80, "diamonds": 0},
	"phases_10": {"gold": 250, "diamonds": 10},
	"phases_20": {"gold": 450, "diamonds": 20},
	"phases_40": {"gold": 900, "diamonds": 50},
	"level_15": {"gold": 300, "diamonds": 15, "item": "music_starlight"},
	"level_30": {"gold": 800, "diamonds": 40, "item": "music_legend"},
}
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
	{"id": "bg_rainbow", "kind": "background", "name": "Fundo Rainbow Pop", "requirement": "Alcance o nível 18", "level": 18},
	{"id": "board_pop", "kind": "board", "name": "Genius Pop", "requirement": "Alcance o nível 20", "level": 20},
	{"id": "bg_twilight", "kind": "background", "name": "Fundo Twilight", "requirement": "Alcance o nível 22", "level": 22},
	{"id": "board_smooth", "kind": "board", "name": "Genius Smooth", "requirement": "Alcance o nível 24", "level": 24},
	{"id": "bg_master", "kind": "background", "name": "Fundo Master Pulse", "requirement": "Alcance o nível 28", "level": 28},
	{"id": "board_master", "kind": "board", "name": "Genius Master", "requirement": "Alcance o nível 30", "level": 30},
	{"id": "music_neon_night", "kind": "music", "name": "Neon Night", "requirement": "Inicial", "level": 1},
	{"id": "music_focus", "kind": "music", "name": "Focus Loop", "requirement": "Alcance o nível 6", "level": 6},
	{"id": "music_starlight", "kind": "music", "name": "Starlight", "requirement": "Alcance o nível 15", "level": 15},
	{"id": "music_legend", "kind": "music", "name": "Legend Pulse", "requirement": "Alcance o nível 30", "level": 30},
]
const SHOP_ITEMS: Array[Dictionary] = [
	{"id": "avatar_neon", "kind": "avatar", "name": "Avatar Neon", "currency": "gold", "cost": 0},
	{"id": "avatar_prisma", "kind": "avatar", "name": "Avatar Prisma", "currency": "gold", "cost": 450},
	{"id": "avatar_diamante", "kind": "avatar", "name": "Avatar Diamante", "currency": "diamonds", "cost": 80},
	{"id": "avatar_pixel", "kind": "avatar", "name": "Avatar Pixel", "currency": "gold", "cost": 650},
	{"id": "avatar_cyber", "kind": "avatar", "name": "Avatar Cyber", "currency": "gold", "cost": 1100},
	{"id": "avatar_lendario", "kind": "avatar", "name": "Avatar Lendário", "currency": "diamonds", "cost": 180},
	{"id": "banner_grid", "kind": "banner", "name": "Banner Grid", "currency": "gold", "cost": 0},
	{"id": "banner_temporada", "kind": "banner", "name": "Banner Temporada", "currency": "gold", "cost": 700},
	{"id": "banner_luxo", "kind": "banner", "name": "Banner Luxo", "currency": "diamonds", "cost": 120},
	{"id": "banner_aurora", "kind": "banner", "name": "Banner Aurora", "currency": "gold", "cost": 600},
	{"id": "banner_arcade", "kind": "banner", "name": "Banner Arcade", "currency": "gold", "cost": 900},
	{"id": "banner_cosmico", "kind": "banner", "name": "Banner Cósmico", "currency": "diamonds", "cost": 160},
	{"id": "style_default", "kind": "name_style", "name": "Nome Padrao", "currency": "gold", "cost": 0},
	{"id": "style_gold", "kind": "name_style", "name": "Nome Dourado", "currency": "gold", "cost": 950},
	{"id": "style_diamond", "kind": "name_style", "name": "Nome Diamante", "currency": "diamonds", "cost": 150},
	{"id": "style_neon", "kind": "name_style", "name": "Nome Neon", "currency": "gold", "cost": 500},
	{"id": "style_arcade", "kind": "name_style", "name": "Nome Arcade", "currency": "gold", "cost": 850},
	{"id": "style_legend", "kind": "name_style", "name": "Nome Lendário", "currency": "diamonds", "cost": 220},
	{"id": "music_arcade", "kind": "music", "name": "Arcade Memory", "currency": "gold", "cost": 900},
	{"id": "music_dream", "kind": "music", "name": "Dream Circuit", "currency": "diamonds", "cost": 90},
]

const MUSIC_THEME_OPTIONS: Array[Dictionary] = [
	{"id": "music_neon_night", "name": "Neon Night"},
	{"id": "music_focus", "name": "Focus Loop"},
	{"id": "music_starlight", "name": "Starlight"},
	{"id": "music_legend", "name": "Legend Pulse"},
	{"id": "music_arcade", "name": "Arcade Memory"},
	{"id": "music_dream", "name": "Dream Circuit"},
]

const BACKGROUND_THEME_OPTIONS: Array[Dictionary] = [
	{"id": "bg_neon", "name": "Neon Grid"},
	{"id": "bg_aurora", "name": "Aurora"},
	{"id": "bg_sunset", "name": "Sunset"},
	{"id": "bg_cyber", "name": "Cyber Blue"},
	{"id": "bg_arcade", "name": "Arcade Pop"},
	{"id": "bg_lime", "name": "Lime Pulse"},
	{"id": "bg_rainbow", "name": "Rainbow Pop"},
	{"id": "bg_twilight", "name": "Twilight"},
	{"id": "bg_master", "name": "Master Pulse"},
]

const BOARD_STYLE_OPTIONS: Array[Dictionary] = [
	{"id": "board_classic", "name": "Clássico", "icon": "◎", "pattern": "Neon profundo"},
	{"id": "board_plasma", "name": "Plasma", "icon": "ϟ", "pattern": "Turquesa e violeta"},
	{"id": "board_solar", "name": "Solar", "icon": "☀", "pattern": "Âmbar escuro"},
	{"id": "board_crystal", "name": "Crystal", "icon": "◆", "pattern": "Tons frios"},
	{"id": "board_void", "name": "Void", "icon": "✦", "pattern": "Cores do espaço"},
	{"id": "board_midnight", "name": "Midnight", "icon": "⋆", "pattern": "Paleta noturna"},
	{"id": "board_candy", "name": "Candy", "icon": "○", "pattern": "Pastel escuro"},
	{"id": "board_pop", "name": "Pop", "icon": "✣", "pattern": "Arcade moderno"},
	{"id": "board_smooth", "name": "Smooth", "icon": "≈", "pattern": "Cores suaves"},
	{"id": "board_master", "name": "Master", "icon": "◇", "pattern": "Paleta premium"},
]

const SOUND_THEME_OPTIONS: Array[Dictionary] = [
	{"id": "sound_classic", "name": "Clasico"},
	{"id": "sound_pop", "name": "Pop"},
	{"id": "sound_retro", "name": "Retro"},
	{"id": "sound_bubble", "name": "Bolha"},
]

const PHASES_PER_SEASON: int = 40
const PHASES_PER_SECTION: int = 10
const PHASE_SECTION_LABELS: Array[String] = ["Treino", "Aquecimento", "Desafio", "Maestria"]

var flash_time: float = 0.46
var sequence: Array[int] = []
var input_index: int = 0
var score: int = 0
var accepting_input: bool = false
var gameplay_mode: String = "menu"
var current_phase: int = 0
var current_phase_goal: int = 0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var session_id: int = 0
var current_back_target: String = "menu"
var current_back_action: Callable = Callable()
var screen_state: String = "menu"
var responsive_layout_queued: bool = false
var active_shop_kind: String = ""
var active_settings_section: String = ""

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
var replay_pattern_button: Button
var in_game_options: PanelContainer
var mute_button: Button
var menu_button: Button
var audio_player: AudioStreamPlayer
var music_player: AudioStreamPlayer
var music_timer: Timer
var music_note_index: int = 0
var splash_layer: CanvasLayer
var splash_root: Control


func _ready() -> void:
	rng.randomize()
	_build_ui()
	resized.connect(_queue_responsive_layout)
	if get_viewport().has_signal("size_changed"):
		get_viewport().connect("size_changed", Callable(self, "_queue_responsive_layout"))
	call_deferred("_apply_responsive_layout")
	call_deferred("_apply_owner_access")
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
	root_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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
	content_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	content_scroll.scroll_deadzone = 12
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

	replay_pattern_button = _make_icon_button("↻", _on_replay_pattern_pressed)
	replay_pattern_button.visible = false
	replay_pattern_button.tooltip_text = "Rever padrão"
	add_child(replay_pattern_button)

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

	music_player = AudioStreamPlayer.new()
	music_player.stream = AudioStreamGenerator.new()
	music_player.volume_db = -22.0
	add_child(music_player)
	music_timer = Timer.new()
	music_timer.wait_time = 0.46
	music_timer.autostart = true
	music_timer.timeout.connect(_on_music_tick)
	add_child(music_timer)

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
	content_scroll.visible = true
	action_row.visible = false
	board.visible = false
	board.enabled = false
	title_label.visible = false
	subtitle_label.visible = false
	score_label.visible = false
	status_label.visible = false
	content_box.alignment = BoxContainer.ALIGNMENT_CENTER

	var menu_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	menu_grid.add_child(_make_feature_tile("JOGAR", "Modos, fases sazonais, infinito e partidas locais.", "MODOS", _show_game_modes, Color(0.0, 0.78, 1.0, 0.78)))
	menu_grid.add_child(_make_feature_tile("PERFIL", "Conta, visual, conquistas, recompensas e historico.", "PROGRESSO", _show_profile, Color(1.0, 0.54, 0.14, 0.82)))
	menu_grid.add_child(_make_feature_tile("LOJA", "Avatares, banners e estilos para personalizar o jogador.", "ITENS", _show_shop, Color(0.35, 1.0, 0.72, 0.78)))
	menu_grid.add_child(_make_feature_tile("AJUSTES", "Tema, paleta, tabuleiro, audio e preferencias.", "CONFIG", _show_settings, Color(0.86, 0.36, 1.0, 0.78)))
	menu_grid.add_child(_make_feature_tile("SAIR", "Fechar o app.", "APP", _quit_game, Color(1.0, 0.22, 0.38, 0.72)))
	content_box.add_child(menu_grid)
	_apply_interface_theme()
	_apply_responsive_layout()


func _show_game_modes() -> void:
	_show_collection_screen("MODOS DE JOGO", "Escolha como jogar", "Temporadas ranqueadas, fases sazonais e modos locais.")
	_set_back_action(_show_menu)
	var mode_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	mode_grid.add_child(_make_feature_tile("INFINITO", "Sequencia crescente para bater recordes e ganhar XP.", "SOLO", _start_survival, Color(0.0, 0.9, 1.0, 0.82)))
	mode_grid.add_child(_make_feature_tile("FASES", "%d desafios da temporada %s." % [PHASES_PER_SEASON, _season_label()], "SAZONAL", _show_season_phases, Color(1.0, 0.72, 0.16, 0.82)))
	mode_grid.add_child(_make_feature_tile("MULTIPLAYER", "Rank, vitorias, derrotas e ranking competitivo.", ScoreStore.rank_name.to_upper(), _show_multiplayer, Color(0.38, 1.0, 0.62, 0.78)))
	mode_grid.add_child(_make_feature_tile("LOCAL", "Crie ou entre em salas na mesma rede Wi-Fi.", "LAN", _show_local_multiplayer, Color(0.9, 0.38, 1.0, 0.78)))
	content_box.add_child(mode_grid)
	_apply_responsive_layout()


func _show_local_multiplayer() -> void:
	_show_collection_screen("MULTIPLAYER LOCAL", "Rede Wi-Fi local", "Preparado para partidas em LAN. O salvamento de historico usa a conta conectada.")
	_set_back_action(_show_game_modes)
	content_box.add_child(_make_section_label("STATUS"))
	content_box.add_child(_make_info_card("Crie ou entre em uma sala na mesma rede Wi-Fi. A camada online esta separada para receber o protocolo de host/cliente sem mexer no progresso."))
	var lobby_grid: GridContainer = _make_card_grid(_responsive_columns(2))
	lobby_grid.add_child(_make_feature_tile("CRIAR SALA", "Hospedar uma partida local nesta rede.", "HOST", Callable(self, "_show_unavailable_notice").bind("Host local preparado para proxima etapa de rede."), Color(0.0, 0.78, 1.0, 0.78)))
	lobby_grid.add_child(_make_feature_tile("ENTRAR", "Conectar por codigo ou IP quando a etapa de rede for ligada.", "CLIENTE", Callable(self, "_show_unavailable_notice").bind("Entrada por IP/codigo preparada para proxima etapa de rede."), Color(0.36, 1.0, 0.72, 0.78)))
	content_box.add_child(lobby_grid)
	_apply_responsive_layout()


func _show_multiplayer() -> void:
	_show_collection_screen("MULTIPLAYER", "Temporada atual: %s" % _season_label(), "Rank por vitorias e derrotas. Bronze/Prata perdem pontos depois de 2 derrotas seguidas; Ouro+ perde na primeira derrota.")
	_set_back_action(_show_game_modes)
	content_box.add_child(_make_info_card("Patente: %s\nPontuacao: %d\nVitorias: %d  Derrotas: %d\nSequencia de derrotas: %d" % [ScoreStore.rank_name, ScoreStore.multiplayer_rating, ScoreStore.multiplayer_wins, ScoreStore.multiplayer_losses, ScoreStore.multiplayer_loss_streak]))
	var multiplayer_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	multiplayer_grid.add_child(_make_feature_tile("BUSCAR PARTIDA", "Matchmaking online preparado para a proxima etapa.", "ONLINE", Callable(self, "_show_unavailable_notice").bind("Matchmaking online preparado para integrar com Supabase Realtime/servidor de partidas."), Color(0.0, 0.78, 1.0, 0.78)))
	multiplayer_grid.add_child(_make_feature_tile("RANKING", "Ver melhores jogadores por pontuacao.", "TOP", _show_leaderboard, Color(1.0, 0.72, 0.18, 0.82)))
	content_box.add_child(multiplayer_grid)
	_apply_responsive_layout()


func _show_season_phases() -> void:
	var season_key: String = _season_key()
	_show_collection_screen("FASES", "%s: %d fases" % [_season_label(), PHASES_PER_SEASON], "Sazonal. Complete fases em 4 seções e desbloqueie recompensas à medida que avança.")
	_set_back_action(_show_game_modes)
	for section_index in range(PHASE_SECTION_LABELS.size()):
		content_box.add_child(_make_section_label("%s %d" % [PHASE_SECTION_LABELS[section_index], section_index + 1]))
		var phase_grid: GridContainer = _make_card_grid(_responsive_columns(5))
		for phase in range(section_index * PHASES_PER_SECTION + 1, (section_index + 1) * PHASES_PER_SECTION + 1):
			phase_grid.add_child(_make_phase_tile(phase, ScoreStore.season_phase_completed(season_key, phase)))
		content_box.add_child(phase_grid)
	content_box.add_child(_make_button("RESETAR FASES DA TEMPORADA", _reset_season_phases))
	_apply_responsive_layout()


func _show_profile() -> void:
	_show_collection_screen("PERFIL", ScoreStore.display_name, "Conta, visual, conquistas, recompensas, amigos e historico.")
	_set_back_action(_show_menu)
	content_box.add_child(_make_info_card("%s\nNÍVEL %d  •  %d/%d XP  •  RECORDE %d\n%d PARTIDAS  •  %d FASES  •  %d OURO  •  %d DIAMANTES\nVisual ativo: %s  •  %s" % [ScoreStore.display_name, ScoreStore.survival_level, ScoreStore.survival_xp, ScoreStore.xp_to_next_survival_level(), ScoreStore.best_survival, ScoreStore.games_played, ScoreStore.completed_phase_count(), ScoreStore.gold, ScoreStore.diamonds, ScoreStore.avatar_id.replace("avatar_", "").capitalize(), ScoreStore.banner_id.replace("banner_", "").capitalize()]))
	content_box.add_child(_make_section_label("●  CONTA E IDENTIDADE"))
	var identity_grid: GridContainer = _make_card_grid(_responsive_columns(2))
	identity_grid.add_child(_make_feature_tile("CONTA", "Login, nuvem e sincronização de progresso.", SupabaseClient.auth_label().to_upper(), _show_account, Color(0.0, 0.78, 1.0, 0.78)))
	identity_grid.add_child(_make_feature_tile("EDITAR PERFIL", "Nome, avatar, banner e estilo.", "VISUAL", _show_profile_editor, Color(1.0, 0.58, 0.14, 0.82)))
	content_box.add_child(identity_grid)
	content_box.add_child(_make_section_label("★  PROGRESSO E COLEÇÃO"))
	var progress_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	progress_grid.add_child(_make_feature_tile("CUSTOMIZAÇÃO", "Fundos e tabuleiros liberados.", "JOGO", _show_customization, Color(0.86, 0.36, 1.0, 0.78)))
	progress_grid.add_child(_make_feature_tile("CONQUISTAS", "Metas permanentes e bônus.", "%d/%d" % [_achievement_count(), ACHIEVEMENTS.size()], _show_achievements, Color(1.0, 0.78, 0.2, 0.82)))
	progress_grid.add_child(_make_feature_tile("RECOMPENSAS", "Itens conquistados por nível.", "%d/%d" % [ScoreStore.unlocked_reward_count(), REWARDS.size()], _show_rewards, Color(0.32, 1.0, 0.72, 0.78)))
	content_box.add_child(progress_grid)
	content_box.add_child(_make_section_label("◎  SOCIAL E ATIVIDADE"))
	var social_grid: GridContainer = _make_card_grid(_responsive_columns(2))
	social_grid.add_child(_make_feature_tile("AMIGOS", "Convites e partidas sociais.", "SOCIAL", _show_friends, Color(0.5, 0.72, 1.0, 0.78)))
	social_grid.add_child(_make_feature_tile("HISTÓRICO", "Partidas locais e na nuvem.", "PARTIDAS", _show_match_history, Color(1.0, 0.36, 0.52, 0.72)))
	content_box.add_child(social_grid)
	_apply_responsive_layout()


func _show_shop() -> void:
	_show_collection_screen("LOJA", "Ouro %d  // Diamantes %d" % [ScoreStore.gold, ScoreStore.diamonds], "Ouro vem das partidas. Diamantes ficam prontos para compra com dinheiro real.")
	_set_back_action(_show_menu)
	active_shop_kind = ""
	content_box.add_child(_make_info_card("SALDO  •  %d OURO  •  %d DIAMANTES\nEscolha uma categoria para ver os itens." % [ScoreStore.gold, ScoreStore.diamonds]))
	var category_grid: GridContainer = _make_card_grid(3)
	category_grid.add_child(_make_feature_tile("AVATARES", "Rostos e símbolos para representar seu perfil.", "●  IDENTIDADE", Callable(self, "_show_shop_category").bind("avatar"), Color(0.0, 0.84, 1.0, 0.82)))
	category_grid.add_child(_make_feature_tile("BANNERS", "Planos de fundo para destacar seu cartão.", "▰  PERFIL", Callable(self, "_show_shop_category").bind("banner"), Color(1.0, 0.62, 0.14, 0.82)))
	category_grid.add_child(_make_feature_tile("ESTILOS DE NOME", "Cores e acabamentos para o nome do jogador.", "✦  TEXTO", Callable(self, "_show_shop_category").bind("name_style"), Color(0.72, 0.34, 1.0, 0.82)))
	category_grid.add_child(_make_feature_tile("MÚSICAS", "Novas trilhas para acompanhar as partidas.", "♫  ÁUDIO", Callable(self, "_show_shop_category").bind("music"), Color(0.24, 0.9, 0.72, 0.82)))
	content_box.add_child(category_grid)
	_apply_responsive_layout()


func _show_shop_category(kind: String) -> void:
	active_shop_kind = kind
	_show_collection_screen(_item_group_label(kind).substr(3), "Ouro %d  // Diamantes %d" % [ScoreStore.gold, ScoreStore.diamonds], "Toque em um item para comprar. Itens adquiridos ficam disponíveis no perfil.")
	_set_back_action(_show_shop)
	var shop_grid: GridContainer = _make_card_grid(3)
	for item in SHOP_ITEMS:
		if String(item["kind"]) == kind:
			shop_grid.add_child(_make_shop_card(item))
	content_box.add_child(shop_grid)
	_apply_responsive_layout()


func _show_achievements() -> void:
	_show_collection_screen("CONQUISTAS", "%d/%d desbloqueadas" % [_achievement_count(), ACHIEVEMENTS.size()], "Objetivos permanentes para dominar o Infinito.")
	_set_back_action(_show_profile)
	var achievement_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	for achievement in ACHIEVEMENTS:
		achievement_grid.add_child(_make_achievement_card(achievement))
	content_box.add_child(achievement_grid)
	_apply_responsive_layout()


func _show_rewards() -> void:
	_show_collection_screen("RECOMPENSAS", "%d/%d liberadas" % [ScoreStore.unlocked_reward_count(), REWARDS.size()], "Itens ganhados ao subir de nivel.")
	_set_back_action(_show_profile)
	var reward_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	for reward in REWARDS:
		reward_grid.add_child(_make_reward_card(reward, false))
	content_box.add_child(reward_grid)
	_apply_responsive_layout()


func _show_customization() -> void:
	_show_collection_screen("CUSTOMIZACAO", "Fundo e estilo do Genius", "Escolha os itens ja liberados.")
	_set_back_action(_show_profile)
	content_box.add_child(_make_section_label("▣  FUNDOS"))
	var background_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	for reward in REWARDS:
		if String(reward["kind"]) == "background":
			background_grid.add_child(_make_reward_card(reward, true))
	content_box.add_child(background_grid)
	content_box.add_child(_make_section_label("◉  TABULEIROS GENIUS"))
	var board_grid: GridContainer = _make_card_grid(_responsive_columns(3))
	for reward in REWARDS:
		if String(reward["kind"]) == "board":
			board_grid.add_child(_make_reward_card(reward, true))
	content_box.add_child(board_grid)
	_apply_responsive_layout()


func _show_settings() -> void:
	_show_collection_screen("CONFIGURACOES", "Preferencias do jogo", "Ajustes salvos automaticamente.")
	_set_back_action(_show_menu)
	active_settings_section = ""
	var settings_grid: GridContainer = _make_card_grid(2)
	settings_grid.add_child(_make_feature_tile("APARÊNCIA", "Tema claro ou escuro da interface.", "☀  TEMA", Callable(self, "_show_settings_section").bind("theme"), Color(1.0, 0.72, 0.18, 0.82)))
	settings_grid.add_child(_make_feature_tile("PALETA", "Cores e atmosfera do plano de fundo.", "◈  CORES", Callable(self, "_show_settings_section").bind("palette"), Color(0.0, 0.82, 1.0, 0.82)))
	settings_grid.add_child(_make_feature_tile("TABULEIRO", "Estilo visual das quatro áreas de jogo.", "▦  GAMEPLAY", Callable(self, "_show_settings_section").bind("board"), Color(0.36, 1.0, 0.68, 0.82)))
	settings_grid.add_child(_make_feature_tile("ÁUDIO", "Som, efeitos e identidade sonora.", "♫  SOM", Callable(self, "_show_settings_section").bind("audio"), Color(0.86, 0.36, 1.0, 0.82)))
	content_box.add_child(settings_grid)
	_apply_responsive_layout()


func _show_settings_section(section: String) -> void:
	active_settings_section = section
	var names: Dictionary = {"theme": "APARÊNCIA", "palette": "PALETA", "board": "TABULEIRO", "audio": "ÁUDIO"}
	_show_collection_screen(String(names.get(section, "CONFIGURAÇÕES")), "Personalize sua experiência", "As alterações são aplicadas e salvas imediatamente.")
	_set_back_action(_show_settings)
	if section == "theme":
		content_box.add_child(_make_section_label("☀  TEMA DA INTERFACE"))
		var theme_grid: GridContainer = _make_card_grid(2)
		theme_grid.add_child(_make_button("TEMA CLARO" if not ScoreStore.is_light_theme() else "TEMA CLARO  // ATIVO", Callable(self, "_set_visual_theme").bind("light")))
		theme_grid.add_child(_make_button("TEMA ESCURO" if ScoreStore.is_light_theme() else "TEMA ESCURO  // ATIVO", Callable(self, "_set_visual_theme").bind("dark")))
		content_box.add_child(theme_grid)
	elif section == "palette":
		content_box.add_child(_make_section_label("◈  PALETAS DE FUNDO"))
		var palette_grid: GridContainer = _make_card_grid(3)
		for theme in BACKGROUND_THEME_OPTIONS:
			var label: String = String(theme["name"])
			if ScoreStore.selected_background == String(theme["id"]):
				label += "  // ATIVA"
			palette_grid.add_child(_make_button(label, Callable(self, "_set_background_theme").bind(String(theme["id"]))))
		content_box.add_child(palette_grid)
	elif section == "board":
		content_box.add_child(_make_section_label("▦  ESTILOS DO TABULEIRO"))
		var board_grid: GridContainer = _make_card_grid(3)
		for style in BOARD_STYLE_OPTIONS:
			var label: String = "%s  %s\n%s" % [String(style["icon"]), String(style["name"]), String(style["pattern"])]
			if ScoreStore.selected_board_style == String(style["id"]):
				label += "  // ATIVO"
			board_grid.add_child(_make_button(label, Callable(self, "_set_board_style").bind(String(style["id"]))))
		content_box.add_child(board_grid)
	elif section == "audio":
		content_box.add_child(_make_section_label("♫  ÁUDIO E EFEITOS"))
		var audio_grid: GridContainer = _make_card_grid(3)
		audio_grid.add_child(_make_button("AUDIO: OFF" if ScoreStore.audio_muted else "AUDIO: ON", _toggle_audio_from_settings))
		for sound in SOUND_THEME_OPTIONS:
			var label: String = String(sound["name"])
			if ScoreStore.selected_sound_theme == String(sound["id"]):
				label += "  // ATIVO"
				audio_grid.add_child(_make_button(label, Callable(self, "_set_sound_theme").bind(String(sound["id"]))))
		content_box.add_child(audio_grid)
		content_box.add_child(_make_section_label("♫  MÚSICA DE FUNDO"))
		var music_grid: GridContainer = _make_card_grid(2)
		for music in MUSIC_THEME_OPTIONS:
			var music_id: String = String(music["id"])
			var owned: bool = ScoreStore.is_reward_unlocked(music_id) or ScoreStore.is_item_purchased(music_id)
			var music_label: String = String(music["name"])
			if ScoreStore.selected_music_theme == music_id:
				music_label += "  // ATIVA"
			elif not owned:
				music_label += "  // BLOQUEADA"
			var music_button: Button = _make_button(music_label, Callable(self, "_set_music_theme").bind(music_id))
			music_button.disabled = not owned
			music_grid.add_child(music_button)
		content_box.add_child(music_grid)
	_apply_responsive_layout()


func _show_account() -> void:
	_show_collection_screen("CONTA E NUVEM", SupabaseClient.auth_label(), "Use email e senha. Ao criar conta, confirme o email antes de entrar.")
	_set_back_action(_show_profile)
	if not SupabaseClient.is_configured():
		content_box.add_child(_make_info_card("Envie a URL do projeto Supabase e a chave publica anon/publishable para eu configurar no codigo."))
		return
	if SupabaseClient.last_error != "":
		content_box.add_child(_make_info_card(SupabaseClient.user_facing_error()))
	if SupabaseClient.is_signed_in():
		content_box.add_child(_make_info_card("Progresso protegido na nuvem. A sincronização acontece automaticamente enquanto você joga."))
		content_box.add_child(_make_button("SINCRONIZAR AGORA", _sync_cloud_now))
		content_box.add_child(_make_button("SAIR DA CONTA", _sign_out_cloud))
		return
	content_box.add_child(_make_info_card("Entre para recuperar seu progresso em qualquer aparelho ou crie uma conta gratuita."))
	var account_grid: GridContainer = _make_card_grid(2)
	account_grid.add_child(_make_feature_tile("ENTRAR", "Acesse uma conta já existente.", "●  CONTA", _show_login_form, Color(0.0, 0.82, 1.0, 0.82)))
	account_grid.add_child(_make_feature_tile("CRIAR CONTA", "Proteja seu progresso com email e senha.", "+  NOVO JOGADOR", _show_signup_form, Color(0.34, 1.0, 0.68, 0.82)))
	content_box.add_child(account_grid)
	_apply_responsive_layout()


func _show_signup_form() -> void:
	_show_collection_screen("CRIAR CONTA", "Proteja seu progresso", "Use um email válido. Você poderá precisar confirmá-lo antes de entrar.")
	_set_back_action(_show_account)
	var create_name_input: LineEdit = _make_text_input("nome do usuario")
	content_box.add_child(create_name_input)
	var create_email_input: LineEdit = _make_text_input("email")
	content_box.add_child(create_email_input)
	var create_password_input: LineEdit = _make_text_input("senha", true)
	content_box.add_child(create_password_input)
	var create_password_confirm_input: LineEdit = _make_text_input("repetir senha", true)
	content_box.add_child(create_password_confirm_input)
	content_box.add_child(_make_button("CRIAR E ENVIAR CONFIRMACAO", Callable(self, "_create_account_from_fields").bind(create_name_input, create_email_input, create_password_input, create_password_confirm_input)))
	_apply_responsive_layout()


func _show_login_form() -> void:
	_show_collection_screen("ENTRAR", "Continue de onde parou", "Seu progresso será carregado e sincronizado automaticamente.")
	_set_back_action(_show_account)
	var login_email_input: LineEdit = _make_text_input("email")
	content_box.add_child(login_email_input)
	var login_password_input: LineEdit = _make_text_input("senha", true)
	content_box.add_child(login_password_input)
	content_box.add_child(_make_button("ENTRAR COM EMAIL", Callable(self, "_login_from_fields").bind(login_email_input, login_password_input)))
	_apply_responsive_layout()


func _show_profile_editor() -> void:
	_show_collection_screen("EDITAR PERFIL", ScoreStore.display_name, "Escolha itens comprados ou liberados.")
	_set_back_action(_show_profile)
	var name_input: LineEdit = LineEdit.new()
	name_input.text = ScoreStore.display_name
	name_input.placeholder_text = "nome do jogador"
	name_input.custom_minimum_size = Vector2(320, 54)
	content_box.add_child(name_input)
	content_box.add_child(_make_section_label("AVATAR"))
	_add_profile_item_buttons("avatar", name_input)
	content_box.add_child(_make_section_label("BANNER"))
	_add_profile_item_buttons("banner", name_input)
	content_box.add_child(_make_section_label("ESTILO DO NOME"))
	_add_profile_item_buttons("name_style", name_input)
	_apply_responsive_layout()


func _show_friends() -> void:
	_show_collection_screen("AMIGOS", "Convites e partidas", "Estrutura de amigos pronta no banco. Convites online entram na etapa de Realtime/matchmaking.")
	_set_back_action(_show_profile)
	content_box.add_child(_make_info_card("Voce podera adicionar amigos, aceitar convites e chamar para partidas. As tabelas e policies estao no SQL incluido."))
	content_box.add_child(_make_button("ADICIONAR AMIGO", Callable(self, "_show_unavailable_notice").bind("Busca por jogador sera ligada ao Supabase apos configurar o projeto.")))
	_apply_responsive_layout()


func _show_match_history() -> void:
	_show_collection_screen("HISTORICO", "Ultimas partidas", "Historico local e em nuvem quando conectado.")
	_set_back_action(_show_profile)
	if not SupabaseClient.is_signed_in():
		content_box.add_child(_make_info_card("Entre em uma conta para carregar o historico salvo no Supabase."))
		_apply_responsive_layout()
		return
	var rows: Array = await SupabaseClient.fetch_match_history()
	if rows.is_empty():
		content_box.add_child(_make_info_card("Nenhuma partida online registrada ainda."))
	for row in rows:
		content_box.add_child(_make_info_card("%s  // %s\nPlacar: %s x %s\nPatente apos partida: %s" % [String(row.get("mode", "partida")), String(row.get("result", "")), str(row.get("player_score", 0)), str(row.get("opponent_score", 0)), String(row.get("rank_after", ""))]))
	_apply_responsive_layout()


func _show_leaderboard() -> void:
	_show_collection_screen("RANKING", "Top jogadores", "Ordenado por pontuacao multiplayer.")
	_set_back_action(_show_multiplayer)
	var rows: Array = await SupabaseClient.fetch_leaderboard()
	if rows.is_empty():
		content_box.add_child(_make_info_card("Ranking indisponivel ate configurar Supabase e jogar partidas ranqueadas."))
	for index in range(rows.size()):
		var row: Dictionary = rows[index]
		content_box.add_child(_make_info_card("#%d  %s\n%s pontos  // %s" % [index + 1, String(row.get("display_name", "Jogador")), str(row.get("multiplayer_rating", 0)), String(row.get("rank_name", ""))]))
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
	content_scroll.scroll_vertical = 0
	content_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.alignment = BoxContainer.ALIGNMENT_BEGIN
	_apply_interface_theme()


func _start_survival() -> void:
	session_id += 1
	screen_state = "game"
	gameplay_mode = "survival"
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
	rng.randomize()
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


func _start_phase(phase_number: int) -> void:
	if ScoreStore.season_phase_completed(_season_key(), phase_number):
		_show_season_phases()
		status_label.text = "Fase %02d já concluída. Escolha uma fase disponível." % phase_number
		return
	session_id += 1
	screen_state = "game"
	gameplay_mode = "phase"
	current_phase = phase_number
	current_phase_goal = clamp(4 + int((phase_number - 1) / 3), 4, 20)
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
	rng.randomize()
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
	var previous_sequence: Array[int] = sequence.duplicate()
	sequence.clear()
	var sequence_length: int = score + 1
	for i in range(sequence_length):
		var next_color: int = rng.randi_range(0, 3)
		if sequence.size() >= 2 and sequence[-1] == sequence[-2]:
			while next_color == sequence[-1]:
				next_color = rng.randi_range(0, 3)
		sequence.append(next_color)
	# Cada rodada é uma nova sequência aleatória, não a rodada anterior com um
	# item anexado. Em uma coincidência completa, troca o último sinal.
	if sequence.size() > 1 and sequence == previous_sequence:
		var replacement: int = rng.randi_range(0, 3)
		while replacement == sequence[-1]:
			replacement = rng.randi_range(0, 3)
		sequence[-1] = replacement
	_update_score_label()
	await _play_current_sequence(current_session)


func _play_current_sequence(current_session: int) -> void:
	accepting_input = false
	board.enabled = false
	input_index = 0
	if replay_pattern_button != null:
		replay_pattern_button.disabled = true
	await get_tree().create_timer(0.3).timeout
	if current_session != session_id:
		return
	for color_index in sequence:
		_play_pad_tone(color_index, 0.18)
		await board.flash_pad(color_index, clampf(flash_time - float(score) * 0.008, 0.2, flash_time))
		if current_session != session_id:
			return
		await get_tree().create_timer(maxf(0.07, flash_time * 0.3)).timeout
		if current_session != session_id:
			return
	accepting_input = true
	board.enabled = true
	if replay_pattern_button != null:
		replay_pattern_button.disabled = false


func _on_replay_pattern_pressed() -> void:
	if not accepting_input or sequence.is_empty():
		return
	var current_session: int = session_id
	Input.vibrate_handheld(18)
	await _play_current_sequence(current_session)


func _on_pad_pressed(index: int) -> void:
	if not accepting_input:
		return
	Input.vibrate_handheld(12)
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
		if current_session == session_id and gameplay_mode == "phase" and score >= current_phase_goal:
			_finish_game()
		elif current_session == session_id:
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

	var new_record: bool = false
	var phase_reward_text: String = ""
	if gameplay_mode == "survival":
		new_record = ScoreStore.record_survival(score)
		_check_achievements()
	else:
		var phase_completed: bool = score >= current_phase_goal
		ScoreStore.record_phase_result(score, phase_completed)
		if phase_completed:
			var season_key: String = _season_key()
			var reward: Dictionary = ScoreStore.complete_season_phase(season_key, current_phase)
			status_label.text = "Fase %02d completa! Recompensa: %d ouro, %d diamantes%s" % [current_phase, int(reward["gold"]), int(reward["diamonds"]), " e item especial" if String(reward.get("item", "")) != "" else ""]
			phase_reward_text = "+%d OURO  •  +%d DIAMANTES%s" % [int(reward["gold"]), int(reward["diamonds"]), "  •  ITEM ESPECIAL" if String(reward.get("item", "")) != "" else ""]
			_check_achievements()
		else:
			status_label.text = "Fase %02d falhou. Tente novamente." % current_phase

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
	var result_title: Label = _make_label(_game_over_title_text(new_record), 30, Color(0.96, 0.99, 1.0))
	var result_score: Label = _make_label("Pontuacao: %d" % score, 16, Color(0.72, 0.84, 1.0))
	content_box.add_child(result_title)
	content_box.add_child(result_score)
	if gameplay_mode == "phase":
		var phase_result: String = "Você concluiu as %d sequências da fase." % current_phase_goal if score >= current_phase_goal else "Você concluiu %d de %d sequências." % [score, current_phase_goal]
		if phase_reward_text != "":
			phase_result += "\nRECOMPENSA  •  %s" % phase_reward_text
		content_box.add_child(_make_info_card(phase_result))
	if gameplay_mode == "survival":
		content_box.add_child(_make_button("JOGAR NOVAMENTE", _start_survival))
	else:
		content_box.add_child(_make_button("REPETIR FASE", Callable(self, "_start_phase").bind(current_phase)))
		content_box.add_child(_make_button("VOLTAR PARA FASES", _show_season_phases))
	content_box.add_child(_make_button("MENU", _show_menu))
	var result_bottom_spacer: Control = Control.new()
	result_bottom_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.add_child(result_bottom_spacer)
	_apply_responsive_layout()


func _create_account_from_fields(name_input: LineEdit, email_input: LineEdit, password_input: LineEdit, password_confirm_input: LineEdit) -> void:
	var name: String = name_input.text.strip_edges()
	var email: String = email_input.text.strip_edges()
	var password: String = password_input.text
	var password_confirm: String = password_confirm_input.text
	if name == "":
		status_label.text = "Informe o nome do usuario."
		return
	if email == "":
		status_label.text = "Informe o email."
		return
	if password.length() < 6:
		status_label.text = "A senha precisa ter pelo menos 6 caracteres."
		return
	if password != password_confirm:
		status_label.text = "As senhas nao conferem."
		return
	await SupabaseClient.sign_up(name, email, password)
	_apply_owner_access()
	_show_account()
	status_label.text = SupabaseClient.last_error if SupabaseClient.last_error != "" else "Verifique seu email para confirmar a conta."


func _login_from_fields(email_input: LineEdit, password_input: LineEdit) -> void:
	if email_input.text.strip_edges() == "" or password_input.text == "":
		status_label.text = "Informe email e senha para entrar."
		return
	var ok: bool = await SupabaseClient.sign_in(email_input.text, password_input.text)
	if ok:
		_apply_owner_access()
	var message: String = SupabaseClient.last_error
	if not ok:
		status_label.text = SupabaseClient.last_error
	_show_account()
	if not ok and message != "":
		status_label.text = message


func _apply_owner_access() -> void:
	if not SupabaseClient.is_signed_in():
		return
	if SupabaseClient.user_email.strip_edges().to_lower() != OWNER_EMAIL:
		return
	ScoreStore.grant_all_content(REWARDS, SHOP_ITEMS)


func _sync_cloud_now() -> void:
	await SupabaseClient.sync_progress()
	await SupabaseClient.save_profile()
	_show_account()


func _sign_out_cloud() -> void:
	await SupabaseClient.sign_out()
	_show_account()


func _record_multiplayer_result(won: bool) -> void:
	var delta: int = ScoreStore.record_multiplayer_result(won)
	await SupabaseClient.record_match("multiplayer", "", won, 1 if won else 0, 0 if won else 1)
	_show_multiplayer()
	status_label.text = "Resultado aplicado: %+d pontos" % delta


func _reset_season_phases() -> void:
	var season_key: String = _season_key()
	ScoreStore.reset_season_phases(season_key)
	_show_season_phases()
	status_label.text = "Fases da temporada reiniciadas. Boa sorte!"


func _buy_shop_item(item: Dictionary) -> void:
	var ok: bool = ScoreStore.purchase_item(String(item["id"]), String(item["currency"]), int(item["cost"]))
	if active_shop_kind != "":
		_show_shop_category(active_shop_kind)
	else:
		_show_shop()
	status_label.text = "Item comprado." if ok else "Moedas insuficientes."


func _equip_profile_item(kind: String, id: String, name_input: LineEdit) -> void:
	var avatar: String = ScoreStore.avatar_id
	var banner: String = ScoreStore.banner_id
	var style: String = ScoreStore.name_style
	if kind == "avatar":
		avatar = id
	elif kind == "banner":
		banner = id
	elif kind == "name_style":
		style = id
	ScoreStore.update_profile(name_input.text, avatar, banner, style, ScoreStore.featured_achievement)
	await SupabaseClient.save_profile()
	_show_profile_editor()


func _show_unavailable_notice(message: String) -> void:
	status_label.text = message


func _update_score_label() -> void:
	score_label.text = "Pontuacao: %d" % score


func _clear_boxes() -> void:
	for child in content_box.get_children():
		child.queue_free()
	for child in action_row.get_children():
		child.queue_free()


func _make_button_grid(columns: int = 2) -> GridContainer:
	var grid: GridContainer = GridContainer.new()
	grid.set_meta("max_columns", columns)
	grid.columns = _responsive_columns(columns)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("hseparation", 14)
	grid.add_theme_constant_override("vseparation", 14)
	return grid


func _make_card_grid(columns: int = 2) -> GridContainer:
	var grid: GridContainer = _make_button_grid(columns)
	grid.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	grid.add_theme_constant_override("hseparation", 16)
	grid.add_theme_constant_override("vseparation", 16)
	return grid


func _apply_grid_columns(node: Node, columns: int) -> void:
	if node is GridContainer:
		(node as GridContainer).columns = columns
	for child in node.get_children():
		_apply_grid_columns(child, columns)


func _responsive_columns(default_columns: int = 2) -> int:
	var viewport_size: Vector2 = size
	if viewport_size.x <= 1.0:
		viewport_size = get_viewport_rect().size
	if viewport_size.x < 620.0:
		return 1
	if viewport_size.x < 980.0:
		return mini(default_columns, 2)
	if viewport_size.x < 1380.0:
		return mini(default_columns, 3)
	return mini(default_columns, 4)


func _refresh_responsive_grids(node: Node) -> void:
	if node is GridContainer and node.has_meta("max_columns"):
		(node as GridContainer).columns = _responsive_columns(int(node.get_meta("max_columns")))
	for child in node.get_children():
		_refresh_responsive_grids(child)


func _make_feature_tile(title: String, description: String, meta: String, callback: Callable, accent: Color, disabled: bool = false) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 214)
	var fill: Color = Color(0.95, 0.98, 1.0, 0.9) if ScoreStore.is_light_theme() else Color(0.012, 0.018, 0.038, 0.93)
	panel.add_theme_stylebox_override("panel", _button_style(fill, accent, 16))

	var box: VBoxContainer = VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)

	var meta_label: Label = _make_label(meta, 12, accent)
	meta_label.custom_minimum_size = Vector2(0, 18)
	meta_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	box.add_child(meta_label)

	var title_label: Label = _make_label(title, 20, Color(0.03, 0.08, 0.14) if ScoreStore.is_light_theme() else Color(0.96, 0.99, 1.0))
	title_label.custom_minimum_size = Vector2(0, 30)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(title_label)

	var desc_label: Label = _make_label(description, 14, Color(0.13, 0.24, 0.36) if ScoreStore.is_light_theme() else Color(0.72, 0.86, 1.0))
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	desc_label.custom_minimum_size = Vector2(0, 48)
	box.add_child(desc_label)

	var button: Button = _make_button(_feature_tile_action(title, meta), callback)
	button.custom_minimum_size = Vector2(0, 58)
	button.disabled = disabled
	box.add_child(button)
	return panel


func _feature_tile_action(title: String, meta: String) -> String:
	match title:
		"JOGAR":
			return "ESCOLHER MODO"
		"PERFIL":
			return "VER PERFIL"
		"LOJA":
			return "VER LOJA"
		"AJUSTES":
			return "CONFIGURAR"
		"SAIR":
			return "FECHAR"
		"INFINITO":
			return "JOGAR"
		"FASES":
			return "VER FASES"
		"MULTIPLAYER":
			return "ENTRAR"
		"LOCAL":
			return "CRIAR OU ENTRAR"
		"CRIAR SALA":
			return "CRIAR"
		"ENTRAR":
			return "ENTRAR"
		"BUSCAR PARTIDA":
			return "BUSCAR"
		"RANKING":
			return "VER RANKING"
		"CONTA":
			return "GERENCIAR"
		"CRIAR CONTA":
			return "COMEÇAR"
		"AVATARES", "BANNERS", "ESTILOS DE NOME", "MÚSICAS":
			return "VER ITENS"
		"APARÊNCIA", "PALETA", "TABULEIRO", "ÁUDIO":
			return "CONFIGURAR"
		"EDITAR":
			return "EDITAR"
		"CUSTOMIZACAO":
			return "PERSONALIZAR"
		"CONQUISTAS":
			return "VER"
		"RECOMPENSAS":
			return "VER"
		"AMIGOS":
			return "VER AMIGOS"
		"HISTORICO":
			return "VER HISTORICO"
		_:
			if meta == "CONCLUIDA":
				return "CONCLUÍDA"
			if meta == "FASE":
				return "JOGAR"
	return "SELECIONAR"


func _make_phase_tile(phase: int, completed: bool) -> PanelContainer:
	var meta: String = "CONCLUIDA" if completed else "FASE"
	var description: String = "Recompensa resgatada" if completed else "Sequencia alvo: %d" % clamp(4 + int((phase - 1) / 3), 4, 20)
	var accent: Color = Color(0.32, 1.0, 0.72, 0.78) if completed else Color(0.0, 0.78, 1.0, 0.78)
	return _make_feature_tile("%02d" % phase, description, meta, Callable(self, "_start_phase").bind(phase), accent, completed)


func _make_button(text: String, callback: Callable) -> Button:
	var button: Button = Button.new()
	var normal_fill: Color = Color(0.96, 0.6, 0.98, 0.96) if ScoreStore.is_light_theme() else Color(0.08, 0.05, 0.18, 0.96)
	var hover_fill: Color = Color(0.9, 0.85, 1.0, 0.98) if ScoreStore.is_light_theme() else Color(0.16, 0.12, 0.28, 0.98)
	var pressed_fill: Color = Color(1.0, 0.5, 0.7, 1.0) if ScoreStore.is_light_theme() else Color(0.13, 0.08, 0.24, 1.0)
	var disabled_fill: Color = Color(0.86, 0.9, 0.95, 0.92) if ScoreStore.is_light_theme() else Color(0.08, 0.08, 0.12, 0.92)
	var font_color: Color = Color(0.1, 0.08, 0.18) if ScoreStore.is_light_theme() else Color(0.98, 0.95, 1.0)
	button.text = text
	button.custom_minimum_size = Vector2(0, 64)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.pressed.connect(callback)
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_stylebox_override("normal", _button_style(normal_fill, Color(0.74, 0.22, 0.95, 0.94), 20))
	button.add_theme_stylebox_override("hover", _button_style(hover_fill, Color(0.98, 0.72, 0.98, 0.96), 20))
	button.add_theme_stylebox_override("pressed", _button_style(pressed_fill, Color(0.98, 0.52, 0.88, 1.0), 20))
	button.add_theme_stylebox_override("disabled", _button_style(disabled_fill, Color(0.36, 0.4, 0.6, 0.8), 20))
	button.add_theme_color_override("font_color", font_color)
	button.add_theme_color_override("font_disabled_color", Color(0.48, 0.56, 0.68))
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


func _make_text_input(placeholder: String, secret: bool = false) -> LineEdit:
	var input: LineEdit = LineEdit.new()
	input.placeholder_text = placeholder
	input.secret = secret
	input.custom_minimum_size = Vector2(320, 54)
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input.add_theme_font_size_override("font_size", 17)
	return input


func _button_style(fill: Color, border: Color, radius: int = 18) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(3)
	style.set_corner_radius_all(radius)
	style.shadow_color = Color(border.r, border.g, border.b, 0.28)
	style.shadow_size = 18
	style.set_content_margin_all(16)
	style.content_margin_top = 14
	style.content_margin_bottom = 14
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


func _set_back_action(action: Callable) -> void:
	current_back_action = action
	_set_back_target("previous" if action.is_valid() else "")


func _on_back_pressed() -> void:
	_handle_back_request()


func _handle_back_request() -> void:
	if screen_state == "game":
		if in_game_options != null and not in_game_options.visible:
			in_game_options.visible = true
		else:
			if gameplay_mode == "phase":
				_show_season_phases()
			else:
				_show_game_modes()
		return

	if screen_state == "collection" or screen_state == "game_over":
		if screen_state == "game_over":
			if gameplay_mode == "phase":
				_show_season_phases()
			else:
				_show_game_modes()
		elif current_back_action.is_valid():
			current_back_action.call()
		else:
			_show_menu()
		return

	if current_back_target == "menu":
		_show_menu()


func _set_game_chrome(in_game: bool) -> void:
	hud_panel.visible = in_game
	hud_reward_label.visible = false
	options_button.visible = in_game
	replay_pattern_button.visible = in_game
	if in_game:
		replay_pattern_button.text = "↻"
	in_game_options.visible = false
	_update_mute_button()


func _update_hud() -> void:
	var xp_needed: int = ScoreStore.xp_to_next_survival_level()
	if gameplay_mode == "phase":
		hud_record_label.text = "FASE %02d" % current_phase
		hud_points_label.text = "SEQUÊNCIA %d/%d" % [mini(score + 1, current_phase_goal), current_phase_goal]
		hud_level_label.text = "META %d" % current_phase_goal
	else:
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
	_show_settings_section("audio")


func _set_visual_theme(value: String) -> void:
	ScoreStore.set_visual_theme(value)
	_apply_unlocked_visuals()
	_show_settings_section("theme")


func _set_background_theme(theme_id: String) -> void:
	ScoreStore.set_background_theme(theme_id)
	_apply_unlocked_visuals()
	_show_settings_section("palette")


func _set_board_style(style_id: String) -> void:
	ScoreStore.set_board_style(style_id)
	_apply_unlocked_visuals()
	_show_settings_section("board")


func _set_sound_theme(theme_id: String) -> void:
	ScoreStore.set_sound_theme(theme_id)
	_show_settings_section("audio")


func _set_music_theme(theme_id: String) -> void:
	ScoreStore.set_music_theme(theme_id)
	music_note_index = 0
	_show_settings_section("audio")


func _update_mute_button() -> void:
	if mute_button != null:
		mute_button.text = "AUDIO: OFF" if ScoreStore.audio_muted else "AUDIO: ON"


func _show_success_feedback() -> void:
	board.call("show_feedback", "success")
	Input.vibrate_handheld(20)
	_play_tone(880.0, 0.12)


func _show_error_feedback() -> void:
	board.call("show_feedback", "error")
	Input.vibrate_handheld(70)
	_play_tone(130.0, 0.28)


func _play_pad_tone(index: int, duration: float) -> void:
	var sound_theme: String = ScoreStore.selected_sound_theme
	var frequencies: Array[float]
	match sound_theme:
		"sound_pop":
			frequencies = [440.0, 570.0, 710.0, 860.0]
		"sound_retro":
			frequencies = [330.0, 392.0, 523.25, 659.25]
		"sound_bubble":
			frequencies = [280.0, 340.0, 420.0, 520.0]
		_:
			frequencies = [392.0, 523.25, 659.25, 783.99]
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


func _on_music_tick() -> void:
	if ScoreStore.audio_muted or music_player == null:
		return
	var melody: Array[float] = _music_melody(ScoreStore.selected_music_theme)
	if melody.is_empty():
		return
	var frequency: float = melody[music_note_index % melody.size()]
	music_note_index += 1
	_play_music_tone(frequency, minf(0.38, music_timer.wait_time * 0.86))


func _music_melody(theme_id: String) -> Array[float]:
	match theme_id:
		"music_focus":
			return [220.0, 261.63, 329.63, 261.63, 246.94, 293.66, 349.23, 293.66]
		"music_starlight":
			return [329.63, 392.0, 493.88, 659.25, 493.88, 440.0, 392.0, 329.63]
		"music_legend":
			return [196.0, 293.66, 392.0, 493.88, 392.0, 587.33, 493.88, 293.66]
		"music_arcade":
			return [261.63, 329.63, 392.0, 523.25, 392.0, 329.63, 293.66, 349.23]
		"music_dream":
			return [174.61, 220.0, 261.63, 329.63, 293.66, 261.63, 220.0, 196.0]
		_:
			return [196.0, 246.94, 293.66, 369.99, 293.66, 246.94, 220.0, 261.63]


func _play_music_tone(frequency: float, duration: float) -> void:
	music_player.stop()
	music_player.play()
	var playback: AudioStreamGeneratorPlayback = music_player.get_stream_playback()
	if playback == null:
		return
	var mix_rate: float = 44100.0
	var frames: int = int(mix_rate * duration)
	for frame in range(frames):
		var t: float = float(frame) / mix_rate
		var attack: float = minf(1.0, t / 0.025)
		var release: float = minf(1.0, float(frames - frame) / (mix_rate * 0.11))
		var sample: float = (sin(TAU * frequency * t) + sin(TAU * frequency * 0.5 * t) * 0.24) * 0.055 * attack * release
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


func _month_key() -> String:
	var date: Dictionary = Time.get_date_dict_from_system()
	return "%04d_%02d" % [int(date["year"]), int(date["month"])]


func _season_label() -> String:
	var date: Dictionary = Time.get_date_dict_from_system()
	var month: int = int(date["month"])
	var season_number: int = int(ceil(float(month) / 2.0))
	return "%04d T%d" % [int(date["year"]), season_number]


func _season_key() -> String:
	var date: Dictionary = Time.get_date_dict_from_system()
	var month: int = int(date["month"])
	var season_number: int = int(ceil(float(month) / 2.0))
	return "%04d_T%d" % [int(date["year"]), season_number]


func _game_over_title_text(new_record: bool) -> String:
	if gameplay_mode == "survival":
		return "NOVO RECORDE" if new_record else "FIM DE JOGO"
	elif score >= current_phase_goal:
		return "FASE CONCLUIDA"
	return "FIM DE FASE"


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


func _quit_game() -> void:
	get_tree().quit()


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
	var reward_gold: int = 0
	var reward_diamonds: int = 0
	var reward_items: Array[String] = []
	for achievement in ACHIEVEMENTS:
		var id: String = String(achievement["id"])
		if ScoreStore.is_achievement_unlocked(id):
			continue
		if _achievement_requirement_met(achievement):
			if ScoreStore.unlock_achievement(id):
				var achievement_reward: Dictionary = ACHIEVEMENT_REWARDS.get(id, {"gold": 50, "diamonds": 0})
				reward_gold += int(achievement_reward.get("gold", 0))
				reward_diamonds += int(achievement_reward.get("diamonds", 0))
				var item_id: String = String(achievement_reward.get("item", ""))
				if item_id != "":
					ScoreStore.unlock_reward(item_id, "music")
					reward_items.append(item_id)
	if reward_gold > 0 or reward_diamonds > 0 or not reward_items.is_empty():
		ScoreStore.add_currency(reward_gold, reward_diamonds)
		if hud_reward_label != null:
			hud_reward_label.text = "CONQUISTA: +%d OURO  +%d DIAMANTES%s" % [reward_gold, reward_diamonds, "  + ITEM" if not reward_items.is_empty() else ""]
			hud_reward_label.visible = true


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
	if type == "phases":
		return ScoreStore.completed_phase_count() >= value
	if type == "gold":
		return ScoreStore.gold >= value
	return false


func _item_group_label(kind: String) -> String:
	match kind:
		"avatar":
			return "●  AVATARES"
		"banner":
			return "▰  BANNERS"
		"name_style":
			return "✦  ESTILOS DE NOME"
		"music":
			return "♫  MÚSICAS"
	return "ITENS"


func _make_info_card(text: String) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.014, 0.021, 0.04, 0.92), Color(0.0, 0.64, 1.0, 0.48), 12))
	var label: Label = _make_label(text, 15, Color(0.82, 0.9, 1.0))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(label)
	return panel


func _make_shop_card(item: Dictionary) -> PanelContainer:
	var id: String = String(item["id"])
	var owned: bool = ScoreStore.is_item_purchased(id)
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 142)
	var border: Color = Color(0.0, 0.95, 0.78, 0.72) if owned else Color(1.0, 0.64, 0.0, 0.74)
	panel.add_theme_stylebox_override("panel", _button_style(Color(0.014, 0.021, 0.04, 0.92), border, 12))
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)
	var currency: String = String(item["currency"])
	var cost: int = int(item["cost"])
	var title: Label = _make_label("%s  %s  // %s" % [_item_group_label(String(item["kind"])).left(1), String(item["name"]), "COMPRADO" if owned else "%d %s" % [cost, currency.to_upper()]], 16, Color(0.96, 0.99, 1.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	box.add_child(title)
	var button: Button = _make_button("USAR NO PERFIL" if owned else "COMPRAR", Callable(self, "_buy_shop_item").bind(item))
	button.disabled = owned
	box.add_child(button)
	return panel


func _add_profile_item_buttons(kind: String, name_input: LineEdit) -> void:
	for item in SHOP_ITEMS:
		if String(item["kind"]) != kind:
			continue
		var id: String = String(item["id"])
		if not ScoreStore.is_item_purchased(id):
			continue
		var selected: bool = (kind == "avatar" and ScoreStore.avatar_id == id) or (kind == "banner" and ScoreStore.banner_id == id) or (kind == "name_style" and ScoreStore.name_style == id)
		content_box.add_child(_make_button("%s%s" % [String(item["name"]), "  // ATIVO" if selected else ""], Callable(self, "_equip_profile_item").bind(kind, id, name_input)))


func _make_achievement_card(achievement: Dictionary) -> PanelContainer:
	var unlocked: bool = ScoreStore.is_achievement_unlocked(String(achievement["id"]))
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 118)
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
	var achievement_reward: Dictionary = ACHIEVEMENT_REWARDS.get(String(achievement["id"]), {"gold": 50, "diamonds": 0})
	var reward_text: String = "RECOMPENSA  •  %d OURO" % int(achievement_reward.get("gold", 0))
	if int(achievement_reward.get("diamonds", 0)) > 0:
		reward_text += "  •  %d DIAMANTES" % int(achievement_reward["diamonds"])
	if String(achievement_reward.get("item", "")) != "":
		reward_text += "  •  ITEM ESPECIAL"
	var reward_label: Label = _make_label(reward_text, 13, Color(1.0, 0.76, 0.22))
	reward_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	reward_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(reward_label)
	return panel


func _make_reward_card(reward: Dictionary, selectable: bool) -> PanelContainer:
	var id: String = String(reward["id"])
	var kind: String = String(reward["kind"])
	var unlocked: bool = ScoreStore.is_reward_unlocked(id)
	var selected: bool = (kind == "background" and ScoreStore.selected_background == id) or (kind == "board" and ScoreStore.selected_board_style == id)
	var panel: PanelContainer = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.custom_minimum_size = Vector2(0, 190 if selectable else 126)
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
	if kind == "board":
		for style in BOARD_STYLE_OPTIONS:
			if String(style["id"]) == id:
				var visual: Label = _make_label("%s  %s" % [String(style["icon"]), String(style["pattern"])], 13, Color(0.62, 0.84, 1.0))
				visual.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
				box.add_child(visual)
				break
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
	_refresh_responsive_grids(root_box)
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

	var max_width: float = 1320.0 if wide else (980.0 if landscape else 540.0)
	var root_width: float = minf(viewport_size.x - float(horizontal_margin * 2), max_width)
	root_box.custom_minimum_size = Vector2(root_width, 0.0)
	if content_scroll != null:
		var scroll_height: float = viewport_size.y - safe_insets.y - safe_insets.w - float(vertical_margin * 2)
		if screen_state == "menu":
			scroll_height -= menu_logo.custom_minimum_size.y
		elif screen_state == "collection":
			scroll_height -= top_bar.size.y + status_label.size.y + 36.0
		elif screen_state == "game_over":
			scroll_height -= gameplay_top_margin
		content_scroll.custom_minimum_size = Vector2(root_width, maxf(260.0, scroll_height))
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

	var board_limit_by_width: float = minf(viewport_size.x - float(horizontal_margin * 2), root_box.custom_minimum_size.x * 1.28)
	var available_game_height: float = viewport_size.y - gameplay_top_margin - safe_insets.w - float(vertical_margin)
	var board_limit_by_height: float = available_game_height * (0.98 if gameplay_layout else (0.54 if landscape else 0.62))
	var board_min: float = 340.0 if low_height else 410.0
	var board_max: float = 680.0 if not wide else 820.0
	if compact:
		board_min = 320.0
	var board_width: float = clampf(minf(board_limit_by_width, board_limit_by_height * 1.28), board_min, board_max)
	var board_height: float = board_width * 0.78
	if board_height > board_limit_by_height:
		board_height = board_limit_by_height
		board_width = board_height * 1.28
	board.custom_minimum_size = Vector2(board_width, board_height)

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
	if replay_pattern_button != null:
		var replay_size: float = clampf(shortest * 0.115, 44.0, 56.0)
		replay_pattern_button.custom_minimum_size = Vector2(replay_size, replay_size)
		replay_pattern_button.size = replay_pattern_button.custom_minimum_size
		replay_pattern_button.position = Vector2(options_button.position.x, options_button.position.y + options_button.custom_minimum_size.y + 10.0)
		replay_pattern_button.add_theme_font_size_override("font_size", int(clampf(replay_size * 0.46, 20.0, 27.0)))
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
			button.custom_minimum_size = Vector2(0, button_height)
			button.add_theme_font_size_override("font_size", font_size)
		_apply_button_metrics(child, button_width, button_height, font_size)
