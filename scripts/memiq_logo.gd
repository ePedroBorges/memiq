extends Control

var glow_phase: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(360, 120)
	set_process(true)


func _process(delta: float) -> void:
	glow_phase = fposmod(glow_phase + delta, TAU)
	queue_redraw()


func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var text_main: String = "MEMI"
	var text_q: String = "Q"
	var font_size: int = int(clampf(size.y * 0.62, 48.0, 108.0))
	var main_size: Vector2 = font.get_string_size(text_main, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var q_size: Vector2 = font.get_string_size(text_q, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var total_width: float = main_size.x + q_size.x - font_size * 0.08
	var origin: Vector2 = Vector2((size.x - total_width) * 0.5, size.y * 0.68)
	var q_origin: Vector2 = origin + Vector2(main_size.x - font_size * 0.08, 0.0)
	var pulse: float = 0.55 + sin(glow_phase * 2.0) * 0.18

	_draw_logo_text(font, text_main, origin + Vector2(0.0, 7.0), font_size, Color(0.0, 0.0, 0.0, 0.55), 4)
	_draw_logo_text(font, text_q, q_origin + Vector2(0.0, 7.0), font_size, Color(0.0, 0.0, 0.0, 0.55), 4)

	for layer in range(5, 0, -1):
		var offset: float = float(layer)
		var alpha: float = 0.055 * float(layer) * pulse
		_draw_logo_text(font, text_main, origin + Vector2(0.0, -offset), font_size, Color(0.2, 0.55, 1.0, alpha), 2)
		_draw_logo_text(font, text_q, q_origin + Vector2(0.0, -offset), font_size, Color(1.0, 0.55, 0.0, alpha * 1.4), 2)

	_draw_logo_text(font, text_main, origin, font_size, Color(0.94, 0.97, 1.0, 1.0), 3)
	_draw_logo_text(font, text_q, q_origin, font_size, Color(1.0, 0.68, 0.0, 1.0), 3)

	var underline_y: float = origin.y + font_size * 0.14
	var line_start: Vector2 = Vector2(origin.x + font_size * 0.1, underline_y)
	var line_end: Vector2 = Vector2(q_origin.x + q_size.x - font_size * 0.15, underline_y)
	draw_line(line_start + Vector2(0.0, 5.0), line_end + Vector2(0.0, 5.0), Color(0.0, 0.0, 0.0, 0.35), 7.0, true)
	draw_line(line_start, line_end, Color(0.0, 0.75, 1.0, 0.42), 4.0, true)
	draw_line(line_end - Vector2(font_size * 0.34, 0.0), line_end, Color(1.0, 0.58, 0.0, 0.82), 5.0, true)


func _draw_logo_text(font: Font, text: String, at: Vector2, font_size: int, color: Color, outline: int) -> void:
	var outline_color: Color = Color(0.02, 0.04, 0.08, color.a * 0.72)
	for x in range(-outline, outline + 1, outline):
		for y in range(-outline, outline + 1, outline):
			if x == 0 and y == 0:
				continue
			draw_string(font, at + Vector2(float(x), float(y)), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, outline_color)

	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, color)
