extends Control

var time: float = 0.0
var theme_id: String = "bg_neon"


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)


func _process(delta: float) -> void:
	time += delta
	queue_redraw()


func set_theme_id(id: String) -> void:
	theme_id = id
	queue_redraw()


func _draw() -> void:
	var palette: Dictionary = _palette()
	draw_rect(Rect2(Vector2.ZERO, size), palette["base"] as Color)

	var center: Vector2 = size * 0.5
	var scan_color: Color = palette["scan"] as Color
	var grid_color: Color = palette["grid"] as Color
	var step: float = 64.0
	var offset: float = fposmod(time * 18.0, step)

	var x: float = -offset
	while x < size.x + step:
		draw_line(Vector2(x, 0.0), Vector2(x + size.y * 0.28, size.y), grid_color, 1.0)
		x += step

	var y: float = fposmod(time * 10.0, step)
	while y < size.y + step:
		draw_line(Vector2(0.0, y), Vector2(size.x, y - size.x * 0.08), grid_color, 1.0)
		y += step

	draw_circle(center + Vector2(-size.x * 0.32, -size.y * 0.22), size.x * 0.34, palette["glow_a"] as Color)
	draw_circle(center + Vector2(size.x * 0.36, size.y * 0.18), size.x * 0.28, palette["glow_b"] as Color)

	for ring in range(4):
		var radius: float = minf(size.x, size.y) * (0.26 + float(ring) * 0.13)
		var hue: float = fposmod(float(palette["hue"]) + time * 0.08 + float(ring) * 0.18, 1.0)
		var color: Color = Color.from_hsv(hue, 0.82, 1.0, 0.13)
		draw_arc(center, radius, time * 0.28 + float(ring), time * 0.28 + float(ring) + PI * 0.72, 96, color, 3.0, true)

	var scan_y: float = fposmod(time * 90.0, size.y + 160.0) - 80.0
	draw_line(Vector2(0.0, scan_y), Vector2(size.x, scan_y), scan_color, 3.0)


func _palette() -> Dictionary:
	if theme_id == "bg_aurora":
		return {
			"base": Color(0.004, 0.012, 0.024, 1.0),
			"scan": Color(0.0, 1.0, 0.78, 0.11),
			"grid": Color(0.02, 0.32, 0.28, 0.13),
			"glow_a": Color(0.0, 0.85, 0.65, 0.04),
			"glow_b": Color(0.55, 0.12, 1.0, 0.035),
			"hue": 0.42,
		}
	if theme_id == "bg_sunset":
		return {
			"base": Color(0.018, 0.008, 0.016, 1.0),
			"scan": Color(1.0, 0.48, 0.0, 0.1),
			"grid": Color(0.34, 0.16, 0.04, 0.13),
			"glow_a": Color(1.0, 0.38, 0.0, 0.04),
			"glow_b": Color(1.0, 0.0, 0.55, 0.032),
			"hue": 0.08,
		}
	if theme_id == "bg_void":
		return {
			"base": Color(0.002, 0.002, 0.012, 1.0),
			"scan": Color(0.65, 0.35, 1.0, 0.1),
			"grid": Color(0.16, 0.08, 0.32, 0.14),
			"glow_a": Color(0.18, 0.0, 0.75, 0.04),
			"glow_b": Color(0.0, 0.7, 1.0, 0.03),
			"hue": 0.68,
		}

	return {
		"base": Color(0.003, 0.004, 0.012, 1.0),
		"scan": Color.from_hsv(fposmod(time * 0.07, 1.0), 0.85, 1.0, 0.09),
		"grid": Color(0.04, 0.16, 0.25, 0.12),
		"glow_a": Color(0.0, 0.45, 1.0, 0.035),
		"glow_b": Color(1.0, 0.0, 0.52, 0.032),
		"hue": 0.0,
	}
