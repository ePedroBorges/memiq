extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(412, 915)
	var scene: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	await process_frame
	var screens: Array[Dictionary] = [
		{"label": "menu", "method": "_show_menu", "args": [], "must_scroll": true},
		{"label": "perfil", "method": "_show_profile", "args": [], "must_scroll": true},
		{"label": "fases", "method": "_show_season_phases", "args": [], "must_scroll": true},
		{"label": "conquistas", "method": "_show_achievements", "args": [], "must_scroll": true},
		{"label": "recompensas", "method": "_show_rewards", "args": [], "must_scroll": true},
		{"label": "customizacao", "method": "_show_customization", "args": [], "must_scroll": true},
		{"label": "loja-avatares", "method": "_show_shop_category", "args": ["avatar"], "must_scroll": false},
		{"label": "ajustes-paleta", "method": "_show_settings_section", "args": ["palette"], "must_scroll": false},
		{"label": "ajustes-tabuleiro", "method": "_show_settings_section", "args": ["board"], "must_scroll": false},
		{"label": "ajustes-audio", "method": "_show_settings_section", "args": ["audio"], "must_scroll": false},
	]
	for screen in screens:
		var ok: bool = await _check_screen(scene, String(screen["label"]), String(screen["method"]), screen["args"], bool(screen["must_scroll"]))
		if not ok:
			quit(1)
			return

	print("SCROLL_SMOKE_OK screens=", screens.size())
	quit(0)


func _check_screen(scene: Control, label: String, method: String, args: Array, must_scroll: bool) -> bool:
	scene.callv(method, args)
	scene.call("_apply_responsive_layout")
	await process_frame
	await process_frame
	var scroll: ScrollContainer = scene.get("content_scroll")
	var scroll_bar: VScrollBar = scroll.get_v_scroll_bar()
	var available_scroll: float = scroll_bar.max_value - scroll_bar.page
	if available_scroll <= 0.0 and must_scroll:
		push_error("A tela '%s' nao criou uma area rolavel no viewport mobile." % label)
		return false
	if available_scroll <= 0.0:
		print("SCROLL_NOT_NEEDED ", label)
		return true
	var drag: InputEventScreenDrag = InputEventScreenDrag.new()
	drag.relative = Vector2(0.0, -140.0)
	scene.call("_input", drag)
	if scroll.scroll_vertical <= 0:
		push_error("O gesto vertical nao moveu a tela '%s'." % label)
		return false
	print("SCROLL_OK ", label, " max=", int(available_scroll), " position=", scroll.scroll_vertical)
	return true
