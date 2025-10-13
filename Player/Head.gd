extends Node3D


@export_node_path("Camera3D") var cam_path := NodePath("Camera")
@onready var cam: Camera3D = get_node(cam_path)

@export var web_sensitivity_multiplier := 3.5
@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0

# ✨ NEW: Smooth interpolation system
var current_rot := Vector3()
var target_rot := Vector3()
@export var smoothing_speed := 30.0  # Higher = snappier, lower = smoother


func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000

	if OS.has_feature("web"):
		mouse_sensitivity *= web_sensitivity_multiplier

	y_limit = deg_to_rad(y_limit)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Update target rotation
		target_rot.y -= event.relative.x * mouse_sensitivity
		target_rot.x = clamp(target_rot.x - event.relative.y * mouse_sensitivity, -y_limit, y_limit)


func _process(delta: float) -> void:
	# Handle joystick
	var joystick_axis := Input.get_vector(&"look_left", &"look_right",
			&"look_down", &"look_up")

	if joystick_axis != Vector2.ZERO:
		target_rot.y -= joystick_axis.x * mouse_sensitivity * 1000.0 * delta
		target_rot.x = clamp(target_rot.x - joystick_axis.y * mouse_sensitivity * 1000.0 * delta, -y_limit, y_limit)

	# ✨ SMOOTH: Interpolate current rotation toward target every frame
	current_rot.x = lerp(current_rot.x, target_rot.x, smoothing_speed * delta)
	current_rot.y = lerp(current_rot.y, target_rot.y, smoothing_speed * delta)

	# Apply smoothed rotation
	rotation.x = current_rot.x
	if get_owner():
		get_owner().rotation.y = current_rot.y
