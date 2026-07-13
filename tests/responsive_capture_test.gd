extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(412, 915)
	var scene: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(scene)
	await create_timer(3.0).timeout
	await _capture(scene, Vector2i(412, 915), "portrait-menu")
	scene.call("_start_survival", "sequence")
	await create_timer(1.1).timeout
	await _capture(scene, Vector2i(412, 915), "portrait-game")
	scene.call("_show_menu")
	await _capture(scene, Vector2i(915, 412), "landscape-menu")
	print("RESPONSIVE_CAPTURE_OK")
	quit(0)


func _capture(scene: Control, viewport_size: Vector2i, file_name: String) -> void:
	root.size = viewport_size
	var physical_aspect: float = float(viewport_size.x) / float(viewport_size.y)
	var virtual_size: Vector2
	if physical_aspect < (1280.0 / 720.0):
		virtual_size = Vector2(1280.0, 1280.0 / physical_aspect)
	else:
		virtual_size = Vector2(720.0 * physical_aspect, 720.0)
	scene.size = virtual_size
	scene.call("_apply_responsive_layout")
	await process_frame
	await process_frame
	var image: Image = root.get_texture().get_image()
	var error: int = image.save_png("res://build/%s.png" % file_name)
	if error != OK:
		push_error("Falha ao salvar captura %s: %d" % [file_name, error])
