extends Control

signal pad_pressed(index: int)

const PAD_COLORS: Array[Color] = [
	Color(0.03, 0.5, 0.58),
	Color(0.62, 0.07, 0.3),
	Color(0.62, 0.35, 0.04),
	Color(0.29, 0.18, 0.62),
]

var active_pad: int = -1
var enabled: bool = false
var pulse: float = 0.0
var rgb_hue: float = 0.0
var style_id: String = "board_classic"
var feedback: String = ""
var feedback_alpha: float = 0.0


func _ready() -> void:
	custom_minimum_size = Vector2(320, 320)
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)


func _process(delta: float) -> void:
	pulse = fposmod(pulse + delta * 2.8, TAU)
	rgb_hue = fposmod(rgb_hue + delta * 0.08, 1.0)
	if feedback_alpha > 0.0:
		feedback_alpha = maxf(0.0, feedback_alpha - delta * 1.9)
		if feedback_alpha <= 0.0:
			feedback = ""
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


func show_feedback(kind: String) -> void:
	feedback = kind
	feedback_alpha = 1.0
	queue_redraw()


func set_style(id: String) -> void:
	style_id = id
	queue_redraw()


func _draw() -> void:
	var board_rect: Rect2 = Rect2(size * 0.025, size * 0.95)
	var scale_unit: float = minf(board_rect.size.x, board_rect.size.y)
	var gap: float = clampf(scale_unit * 0.028, 10.0, 14.0)
	var inset: float = clampf(scale_unit * 0.022, 8.0, 12.0)
	var pad_corner: float = clampf(scale_unit * 0.055, 18.0, 30.0)
	var board_corner: float = pad_corner + inset
	var pads_rect: Rect2 = board_rect.grow(-inset)
	var shadow_rect: Rect2 = Rect2(board_rect.position + Vector2(0.0, 10.0), board_rect.size)
	_draw_rounded_rect(shadow_rect, board_corner, Color(0.0, 0.0, 0.0, 0.44), Color.TRANSPARENT, 0.0)
	_draw_rounded_rect(board_rect, board_corner, Color(0.006, 0.01, 0.019, 1.0), Color(0.08, 0.15, 0.22, 0.9), 3.0)

	if feedback_alpha > 0.0:
		var feedback_color: Color = Color(0.18, 1.0, 0.46, 0.24 * feedback_alpha)
		if feedback == "error":
			feedback_color = Color(1.0, 0.06, 0.08, 0.3 * feedback_alpha)
		_draw_rounded_rect(board_rect.grow(8.0 + sin(pulse * 2.0) * 3.0), board_corner + 8.0, Color.TRANSPARENT, Color(feedback_color.r, feedback_color.g, feedback_color.b, minf(0.9, feedback_alpha)), 7.0)

	for index in range(4):
		var color: Color = _pad_color(index)
		var brightness: float = 0.4
		if feedback_alpha > 0.0 and feedback == "success":
			brightness = 1.05
		elif feedback_alpha > 0.0 and feedback == "error":
			brightness = 0.22 + sin(pulse * 7.0) * 0.12
		elif active_pad == index:
			brightness = 1.0
		elif enabled:
			brightness = 0.54

		var pad_color: Color = Color(
			minf(color.r * brightness, 1.0),
			minf(color.g * brightness, 1.0),
			minf(color.b * brightness, 1.0),
			1.0
		)

		var pad_rect: Rect2 = _pad_rect(index, pads_rect, gap)
		_draw_rounded_rect(Rect2(pad_rect.position + Vector2(0.0, 4.0), pad_rect.size), pad_corner, Color(0.0, 0.0, 0.0, 0.3), Color.TRANSPARENT, 0.0)
		_draw_rounded_rect(pad_rect, pad_corner, pad_color, Color(color.r, color.g, color.b, 0.42), 2.0)
		_draw_pad_highlight(pad_rect, pad_corner)

		if active_pad == index:
			_draw_rounded_rect(pad_rect.grow(4.0), pad_corner + 4.0, Color(color.r, color.g, color.b, 0.12), Color(color.r, color.g, color.b, 0.7), 4.0)



func _pad_rect(index: int, board_rect: Rect2, gap: float) -> Rect2:
	var half: Vector2 = (board_rect.size - Vector2.ONE * gap) * 0.5
	var origin: Vector2 = board_rect.position
	if index % 2 == 1:
		origin.x += half.x + gap
	if index >= 2:
		origin.y += half.y + gap
	return Rect2(origin, half)


func _draw_rounded_rect(rect: Rect2, radius: float, fill: Color, border: Color, border_width: float) -> void:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = fill
	style.corner_radius_top_left = int(radius)
	style.corner_radius_top_right = int(radius)
	style.corner_radius_bottom_left = int(radius)
	style.corner_radius_bottom_right = int(radius)
	if border_width > 0.0:
		style.border_color = border
		style.set_border_width_all(int(border_width))
	draw_style_box(style, rect)


func _draw_pad_highlight(rect: Rect2, corner: float) -> void:
	var highlight: Rect2 = Rect2(rect.position + Vector2(12.0, 10.0), Vector2(rect.size.x - 24.0, rect.size.y * 0.12))
	_draw_rounded_rect(highlight, corner * 0.28, Color(1.0, 1.0, 1.0, 0.018), Color.TRANSPARENT, 0.0)


func _draw_pad_pattern(index: int, rect: Rect2, color: Color, alpha: float) -> void:
	var c: Vector2 = rect.get_center()
	var unit: float = minf(rect.size.x, rect.size.y)
	var ink: Color = Color(1.0, 1.0, 1.0, alpha)
	if style_id == "board_plasma":
		var bolt: PackedVector2Array = PackedVector2Array([c + Vector2(-unit * 0.18, -unit * 0.28), c + Vector2(unit * 0.02, -unit * 0.06), c + Vector2(-unit * 0.06, -unit * 0.06), c + Vector2(unit * 0.18, unit * 0.28), c + Vector2(unit * 0.04, unit * 0.04), c + Vector2(unit * 0.12, unit * 0.04)])
		draw_polyline(bolt, ink, maxf(5.0, unit * 0.035), true)
	elif style_id == "board_solar":
		draw_circle(c, unit * 0.13, ink)
		for ray in range(8):
			var direction: Vector2 = Vector2.from_angle(float(ray) * TAU / 8.0)
			draw_line(c + direction * unit * 0.19, c + direction * unit * 0.3, ink, maxf(3.0, unit * 0.018), true)
	elif style_id == "board_crystal" or style_id == "board_master":
		var diamond: PackedVector2Array = PackedVector2Array([c + Vector2(0.0, -unit * 0.28), c + Vector2(unit * 0.22, 0.0), c + Vector2(0.0, unit * 0.28), c + Vector2(-unit * 0.22, 0.0)])
		draw_colored_polygon(diamond, Color(1.0, 1.0, 1.0, alpha * 0.32))
		draw_polyline(PackedVector2Array([diamond[0], diamond[1], diamond[2], diamond[3], diamond[0]]), ink, maxf(3.0, unit * 0.016), true)
	elif style_id == "board_void" or style_id == "board_midnight":
		for star in range(7):
			var sx: float = rect.position.x + rect.size.x * (0.18 + fposmod(float(star * 37 + index * 13), 61.0) / 100.0)
			var sy: float = rect.position.y + rect.size.y * (0.18 + fposmod(float(star * 23 + index * 17), 61.0) / 100.0)
			draw_circle(Vector2(sx, sy), 2.5 + float(star % 3), ink)
	elif style_id == "board_candy":
		for bubble in range(4):
			var offset: Vector2 = Vector2((float(bubble % 2) - 0.5) * unit * 0.34, (float(bubble / 2) - 0.5) * unit * 0.3)
			draw_circle(c + offset, unit * (0.075 + float(bubble % 2) * 0.018), Color(1.0, 1.0, 1.0, alpha * 0.24))
	elif style_id == "board_pop":
		for confetti in range(7):
			var angle: float = float(confetti) * 2.1 + float(index)
			var at: Vector2 = c + Vector2(cos(angle) * unit * 0.26, sin(angle * 1.4) * unit * 0.24)
			draw_line(at, at + Vector2.from_angle(angle) * unit * 0.065, ink, maxf(3.0, unit * 0.018), true)
	elif style_id == "board_smooth":
		for wave in range(3):
			var y: float = c.y + (float(wave) - 1.0) * unit * 0.12
			draw_arc(Vector2(c.x - unit * 0.08, y), unit * 0.18, PI * 0.15, PI * 0.85, 18, ink, maxf(3.0, unit * 0.016), true)
	else:
		var inset: Rect2 = rect.grow(-unit * 0.22)
		draw_arc(inset.get_center(), unit * 0.12, 0.0, TAU, 32, ink, maxf(3.0, unit * 0.018), true)


func _draw_center_logo(center: Vector2, inner_radius: float) -> void:
	var font: Font = ThemeDB.fallback_font
	var font_size: int = int(clampf(inner_radius * 0.42, 12.0, 17.0))
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
	var board_rect: Rect2 = Rect2(size * 0.025, size * 0.95)
	var scale_unit: float = minf(board_rect.size.x, board_rect.size.y)
	var inset: float = clampf(scale_unit * 0.022, 8.0, 12.0)
	var pads_rect: Rect2 = board_rect.grow(-inset)
	var gap: float = clampf(scale_unit * 0.028, 10.0, 14.0)
	if not pads_rect.has_point(position):
		return -1
	# O corredor central evita toques ambíguos, mas mantém cada botão grande o
	# bastante para ser alcançado confortavelmente com os dois polegares.
	if absf(position.x - center.x) <= gap * 0.5 or absf(position.y - center.y) <= gap * 0.5:
		return -1
	if position.x < center.x and position.y < center.y:
		return 0
	if position.x >= center.x and position.y < center.y:
		return 1
	if position.x < center.x and position.y >= center.y:
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
	if style_id == "board_crystal":
		var crystal_colors: Array[Color] = [
			Color(0.0, 0.9, 0.9),
			Color(1.0, 0.22, 0.72),
			Color(0.92, 1.0, 0.2),
			Color(0.24, 0.55, 1.0),
		]
		return crystal_colors[index]
	if style_id == "board_midnight":
		var midnight_colors: Array[Color] = [
			Color(0.08, 0.62, 0.38),
			Color(0.74, 0.08, 0.14),
			Color(0.85, 0.66, 0.04),
			Color(0.1, 0.22, 0.78),
		]
		return midnight_colors[index]
	if style_id == "board_candy":
		var candy_colors: Array[Color] = [
			Color(0.22, 1.0, 0.58),
			Color(1.0, 0.38, 0.58),
			Color(1.0, 0.86, 0.25),
			Color(0.36, 0.72, 1.0),
		]
		return candy_colors[index]
	if style_id == "board_pop":
		return [Color(0.12, 1.0, 0.54), Color(1.0, 0.24, 0.52), Color(1.0, 0.78, 0.08), Color(0.18, 0.62, 1.0)][index]
	if style_id == "board_smooth":
		return [Color(0.18, 0.76, 0.5), Color(0.86, 0.24, 0.3), Color(0.92, 0.72, 0.18), Color(0.18, 0.48, 0.86)][index]
	if style_id == "board_master":
		return [Color(0.1, 1.0, 0.68), Color(1.0, 0.18, 0.38), Color(1.0, 0.7, 0.04), Color(0.34, 0.3, 1.0)][index]

	return PAD_COLORS[index]


func _style_hue_shift() -> float:
	if style_id == "board_plasma":
		return 0.78
	if style_id == "board_solar":
		return 0.1
	if style_id == "board_void":
		return 0.55
	if style_id == "board_crystal":
		return 0.48
	if style_id == "board_midnight":
		return 0.63
	if style_id == "board_candy":
		return 0.93
	if style_id == "board_pop":
		return 0.88
	if style_id == "board_smooth":
		return 0.52
	if style_id == "board_master":
		return 0.12

	return 0.0
