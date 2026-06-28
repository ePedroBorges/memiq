extends Control

var glow_phase: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(420, 188)
	set_process(true)


func _process(delta: float) -> void:
	glow_phase = fposmod(glow_phase + delta, TAU)
	queue_redraw()


func _draw() -> void:
	var font: Font = ThemeDB.fallback_font
	var word: String = "MEMI"
	var font_size: int = int(clampf(size.y * 0.6, 64.0, 132.0))
	var word_size: Vector2 = font.get_string_size(word, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	var q_radius: float = font_size * 0.31
	var q_gap: float = font_size * 0.16
	var total_width: float = word_size.x + q_gap + q_radius * 2.15
	var baseline_y: float = size.y * 0.64
	var origin: Vector2 = Vector2((size.x - total_width) * 0.5, baseline_y)
	var q_center: Vector2 = Vector2(origin.x + word_size.x + q_gap + q_radius, baseline_y - font_size * 0.33)
	var pulse: float = 0.62 + sin(glow_phase * 2.0) * 0.16

	var plate_rect: Rect2 = Rect2(Vector2(origin.x - font_size * 0.3, baseline_y - font_size * 0.98), Vector2(total_width + font_size * 0.54, font_size * 1.22))
	draw_rect(plate_rect.grow(14.0), Color(0.0, 0.0, 0.0, 0.22), false, 3.0)
	draw_line(plate_rect.position + Vector2(font_size * 0.08, plate_rect.size.y), plate_rect.position + plate_rect.size - Vector2(font_size * 0.08, 0.0), Color(0.0, 0.78, 1.0, 0.34), 4.0, true)
	draw_line(plate_rect.position + Vector2(font_size * 0.08, 0.0), plate_rect.position + Vector2(font_size * 0.46, 0.0), Color(1.0, 0.7, 0.12, 0.64), 4.0, true)
	draw_line(plate_rect.position + Vector2(plate_rect.size.x - font_size * 0.46, 0.0), plate_rect.position + Vector2(plate_rect.size.x - font_size * 0.08, 0.0), Color(0.0, 0.78, 1.0, 0.56), 4.0, true)

	for layer in range(5, 0, -1):
		var alpha: float = 0.045 * float(layer) * pulse
		_draw_logo_text(font, word, origin + Vector2(0.0, -float(layer)), font_size, Color(0.0, 0.74, 1.0, alpha), 1)
		draw_arc(q_center, q_radius + float(layer) * 1.4, 0.0, TAU, 96, Color(1.0, 0.66, 0.08, alpha * 1.65), 4.0, true)

	_draw_logo_text(font, word, origin + Vector2(0.0, 4.0), font_size, Color(0.0, 0.0, 0.0, 0.5), 2)
	_draw_logo_text(font, word, origin, font_size, Color(0.94, 0.98, 1.0, 1.0), 2)
	draw_arc(q_center + Vector2(0.0, 5.0), q_radius, 0.0, TAU, 96, Color(0.0, 0.0, 0.0, 0.5), 9.0, true)
	draw_arc(q_center, q_radius, 0.0, TAU, 96, Color(1.0, 0.7, 0.12, 1.0), 9.0, true)
	draw_arc(q_center, q_radius * 0.72, PI * 1.08, PI * 1.88, 48, Color(0.0, 0.78, 1.0, 0.7), 4.0, true)

	var tail_start: Vector2 = q_center + Vector2(q_radius * 0.44, q_radius * 0.43)
	var tail_end: Vector2 = q_center + Vector2(q_radius * 1.08, q_radius * 0.98)
	draw_line(tail_start + Vector2(0.0, 4.0), tail_end + Vector2(0.0, 4.0), Color(0.0, 0.0, 0.0, 0.45), 9.0, true)
	draw_line(tail_start, tail_end, Color(1.0, 0.7, 0.12, 1.0), 9.0, true)

	var accent_start: Vector2 = Vector2(origin.x + font_size * 0.08, baseline_y + font_size * 0.12)
	var accent_end: Vector2 = Vector2(q_center.x + q_radius * 0.82, accent_start.y)
	draw_line(accent_start, accent_end, Color(0.0, 0.78, 1.0, 0.5), 3.0, true)
	draw_line(Vector2(q_center.x + q_radius * 0.18, accent_start.y), accent_end, Color(1.0, 0.7, 0.12, 0.9), 4.0, true)


func _draw_logo_text(font: Font, text: String, at: Vector2, font_size: int, color: Color, outline: int) -> void:
	var outline_color: Color = Color(0.01, 0.025, 0.045, color.a * 0.8)
	for x in range(-outline, outline + 1, outline):
		for y in range(-outline, outline + 1, outline):
			if x == 0 and y == 0:
				continue
			draw_string(font, at + Vector2(float(x), float(y)), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, outline_color)

	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, color)
