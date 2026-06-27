extends Control

signal pad_pressed(index: int)

const PAD_COLORS: Array[Color] = [
	Color(0.03, 0.86, 0.32),
	Color(0.94, 0.06, 0.1),
	Color(1.0, 0.82, 0.05),
	Color(0.04, 0.32, 0.96),
]

var active_pad: int = -1
var enabled: bool = false
var pulse: float = 0.0
var rgb_hue: float = 0.0
var style_id: String = "board_classic"


func _ready() -> void:
	custom_minimum_size = Vector2(320, 320)
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)


func _process(delta: float) -> void:
	pulse = fposmod(pulse + delta * 2.8, TAU)
	rgb_hue = fposmod(rgb_hue + delta * 0.08, 1.0)
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if not enabled:
		return

	var pressed: bool = false
	var position: Vector2 = Vector2.ZERO
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pressed = true
		position = event.position
	elif event is InputEventScreenTouch and event.pressed:
		pressed = true
		position = event.position

	if not pressed:
		return

	var index: int = _pad_at(position)
	if index >= 0:
		pad_pressed.emit(index)


func flash_pad(index: int, seconds: float = 0.32) -> void:
	active_pad = index
	queue_redraw()
	await get_tree().create_timer(seconds).timeout
	if active_pad == index:
		active_pad = -1
		queue_redraw()


func set_style(id: String) -> void:
	style_id = id
	queue_redraw()


func _draw() -> void:
	var center: Vector2 = size * 0.5
	var radius: float = minf(size.x, size.y) * 0.47
	var gap: float = maxf(10.0, radius * 0.04)
	var inner_radius: float = radius * 0.28
	var rgb: Color = Color.from_hsv(fposmod(rgb_hue + _style_hue_shift(), 1.0), 0.82, 1.0, 0.34 + sin(pulse) * 0.1)

	draw_circle(center + Vector2(0.0, radius * 0.035), radius + 22.0, Color(0.0, 0.0, 0.0, 0.42))
	draw_circle(center, radius + 18.0, Color(0.006, 0.008, 0.016, 1.0))
	draw_arc(center, radius + 12.0, 0.0, TAU, 180, rgb, 11.0, true)
	draw_arc(center, radius + 27.0, 0.0, TAU, 180, Color.from_hsv(fposmod(rgb_hue + 0.34, 1.0), 0.86, 1.0, 0.18), 5.0, true)
	draw_arc(center, radius - 2.0, 0.0, TAU, 180, Color(1.0, 1.0, 1.0, 0.055), 2.0, true)

	for index in range(4):
		var color: Color = _pad_color(index)
		var brightness: float = 0.5
		if active_pad == index:
			brightness = 1.22
		elif enabled:
			brightness = 0.72

		var pad_color: Color = Color(
			minf(color.r * brightness, 1.0),
			minf(color.g * brightness, 1.0),
			minf(color.b * brightness, 1.0),
			1.0
		)

		_draw_pad(index, center, inner_radius + gap, radius - gap, pad_color)
		_draw_pad_highlight(index, center, inner_radius + gap, radius - gap)

		if active_pad == index:
			_draw_pad(index, center, inner_radius + gap * 0.35, radius + 6.0, Color(color.r, color.g, color.b, 0.2))

	var separator_color: Color = Color(0.0, 0.0, 0.0, 0.78)
	draw_line(center + Vector2(-radius + gap * 0.5, 0.0), center + Vector2(-inner_radius - gap * 0.25, 0.0), separator_color, gap, true)
	draw_line(center + Vector2(inner_radius + gap * 0.25, 0.0), center + Vector2(radius - gap * 0.5, 0.0), separator_color, gap, true)
	draw_line(center + Vector2(0.0, -radius + gap * 0.5), center + Vector2(0.0, -inner_radius - gap * 0.25), separator_color, gap, true)
	draw_line(center + Vector2(0.0, inner_radius + gap * 0.25), center + Vector2(0.0, radius - gap * 0.5), separator_color, gap, true)

	draw_circle(center + Vector2(0.0, inner_radius * 0.07), inner_radius + 11.0, Color(0.0, 0.0, 0.0, 0.45))
	draw_arc(center, inner_radius + 12.0, 0.0, TAU, 130, Color.from_hsv(fposmod(rgb_hue + 0.6 + _style_hue_shift(), 1.0), 0.8, 1.0, 0.35), 6.0, true)
	draw_circle(center, inner_radius + 5.0, Color(0.006, 0.008, 0.015, 1.0))
	draw_arc(center, inner_radius + 1.0, 0.0, TAU, 110, Color(1.0, 1.0, 1.0, 0.08), 2.0, true)
	draw_arc(center, inner_radius - 7.0, PI * 1.05, PI * 1.95, 64, Color(0.0, 0.75, 1.0, 0.18), 3.0, true)
	_draw_center_logo(center, inner_radius)



func _draw_pad(index: int, center: Vector2, inner_radius: float, outer_radius: float, color: Color) -> void:
	var ranges: Array[Vector2] = [
		Vector2(PI, PI * 1.5),
		Vector2(PI * 1.5, TAU),
		Vector2(PI * 0.5, PI),
		Vector2(0.0, PI * 0.5),
	]
	var angle_range: Vector2 = ranges[index]
	var points: Array[Vector2] = []
	var steps: int = 26

	for step in range(steps + 1):
		var angle: float = lerpf(angle_range.x, angle_range.y, float(step) / steps)
		points.append(center + Vector2(cos(angle), sin(angle)) * outer_radius)

	for step in range(steps, -1, -1):
		var angle: float = lerpf(angle_range.x, angle_range.y, float(step) / steps)
		points.append(center + Vector2(cos(angle), sin(angle)) * inner_radius)

	draw_colored_polygon(points, color)


func _draw_pad_highlight(index: int, center: Vector2, inner_radius: float, outer_radius: float) -> void:
	var ranges: Array[Vector2] = [
		Vector2(PI, PI * 1.5),
		Vector2(PI * 1.5, TAU),
		Vector2(PI * 0.5, PI),
		Vector2(0.0, PI * 0.5),
	]
	var angle_range: Vector2 = ranges[index]
	var mid_angle: float = (angle_range.x + angle_range.y) * 0.5
	var highlight_center: Vector2 = center + Vector2(cos(mid_angle), sin(mid_angle)) * ((inner_radius + outer_radius) * 0.52)
	var highlight_radius: float = (outer_radius - inner_radius) * 0.42
	draw_circle(highlight_center, highlight_radius, Color(1.0, 1.0, 1.0, 0.035))


func _draw_center_logo(center: Vector2, inner_radius: float) -> void:
	var font: Font = ThemeDB.fallback_font
	var font_size: int = int(clampf(inner_radius * 0.42, 24.0, 48.0))
	var main_text: String = "MEMI"
	var q_text: String = "Q"
	var main_size: Vector2 = font.get_string_size(main_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	var q_size: Vector2 = font.get_string_size(q_text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	var total_width: float = main_size.x + q_size.x - font_size * 0.08
	var origin: Vector2 = center + Vector2(-total_width * 0.5, font_size * 0.32)
	var q_origin: Vector2 = origin + Vector2(main_size.x - font_size * 0.08, 0.0)
	var glow: float = 0.45 + sin(pulse * 1.7) * 0.12

	_draw_logo_text(font, main_text, origin + Vector2(0.0, 3.0), font_size, Color(0.0, 0.0, 0.0, 0.55), 3)
	_draw_logo_text(font, q_text, q_origin + Vector2(0.0, 3.0), font_size, Color(0.0, 0.0, 0.0, 0.55), 3)
	_draw_logo_text(font, main_text, origin + Vector2(0.0, -2.0), font_size, Color(0.23, 0.58, 1.0, glow * 0.18), 2)
	_draw_logo_text(font, q_text, q_origin + Vector2(0.0, -2.0), font_size, Color(1.0, 0.58, 0.0, glow * 0.32), 2)
	_draw_logo_text(font, main_text, origin, font_size, Color(0.92, 0.96, 1.0, 1.0), 2)
	_draw_logo_text(font, q_text, q_origin, font_size, Color(1.0, 0.67, 0.0, 1.0), 2)

	var underline_y: float = origin.y + font_size * 0.15
	draw_line(Vector2(origin.x + font_size * 0.06, underline_y), Vector2(q_origin.x + q_size.x - font_size * 0.14, underline_y), Color(0.0, 0.75, 1.0, 0.36), 2.0, true)
	draw_line(Vector2(q_origin.x + q_size.x - font_size * 0.42, underline_y), Vector2(q_origin.x + q_size.x - font_size * 0.14, underline_y), Color(1.0, 0.58, 0.0, 0.78), 3.0, true)


func _draw_logo_text(font: Font, text: String, at: Vector2, font_size: int, color: Color, outline: int) -> void:
	var outline_color: Color = Color(0.015, 0.025, 0.045, color.a * 0.76)
	for x in range(-outline, outline + 1, outline):
		for y in range(-outline, outline + 1, outline):
			if x == 0 and y == 0:
				continue
			draw_string(font, at + Vector2(float(x), float(y)), text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, outline_color)

	draw_string(font, at, text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, color)


func _pad_at(position: Vector2) -> int:
	var center: Vector2 = size * 0.5
	var offset: Vector2 = position - center
	var radius: float = minf(size.x, size.y) * 0.47
	var inner_radius: float = radius * 0.26
	var distance: float = offset.length()

	if distance < inner_radius or distance > radius:
		return -1

	if offset.x < 0.0 and offset.y < 0.0:
		return 0
	if offset.x >= 0.0 and offset.y < 0.0:
		return 1
	if offset.x < 0.0 and offset.y >= 0.0:
		return 2
	return 3


func _pad_color(index: int) -> Color:
	if style_id == "board_plasma":
		var plasma_colors: Array[Color] = [
			Color(0.08, 1.0, 0.76),
			Color(1.0, 0.1, 0.48),
			Color(1.0, 0.62, 0.06),
			Color(0.42, 0.16, 1.0),
		]
		return plasma_colors[index]
	if style_id == "board_solar":
		var solar_colors: Array[Color] = [
			Color(0.18, 0.92, 0.34),
			Color(1.0, 0.25, 0.08),
			Color(1.0, 0.78, 0.02),
			Color(0.0, 0.58, 1.0),
		]
		return solar_colors[index]
	if style_id == "board_void":
		var void_colors: Array[Color] = [
			Color(0.0, 0.78, 0.62),
			Color(0.82, 0.0, 0.62),
			Color(0.72, 0.62, 0.0),
			Color(0.14, 0.24, 0.92),
		]
		return void_colors[index]

	return PAD_COLORS[index]


func _style_hue_shift() -> float:
	if style_id == "board_plasma":
		return 0.78
	if style_id == "board_solar":
		return 0.1
	if style_id == "board_void":
		return 0.55

	return 0.0
