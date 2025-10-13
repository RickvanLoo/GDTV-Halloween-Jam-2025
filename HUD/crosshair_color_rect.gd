extends ColorRect

@export var dot_size: float = 8.0
@export var border_thickness: float = 1.0
@export var dot_color: Color = Color(1, 1, 1, 0.7)  
@export var border_color: Color = Color(0, 0, 0, 0.3)

func _ready():
	color = Color.TRANSPARENT

	var total_size = dot_size + (border_thickness * 2)
	size = Vector2(total_size, total_size)

	set_anchors_preset(Control.PRESET_CENTER)
	pivot_offset = size / 2

	position = get_viewport_rect().size / 2 - size / 2

func _draw():
	var center = size / 2
	var radius = dot_size / 2

	draw_circle(center, radius + border_thickness, border_color)
	draw_circle(center, radius, dot_color)

func _process(_delta):
	position = get_viewport_rect().size / 2 - size / 2
	queue_redraw()
