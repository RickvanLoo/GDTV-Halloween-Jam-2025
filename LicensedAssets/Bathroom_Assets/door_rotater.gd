extends Node3D

@export var closed_degrees: float = 0.0
@export var opened_degrees: float = -90.0
@export var rotation_duration: float = 0.5

var opened: bool = false
var player_nearby: bool = false
var is_moving: bool = false

@onready var door_sound: AudioStreamPlayer3D = $"../AudioStreamPlayer3D"

func setDefaultRotation(val: float):
	rotation.y = deg_to_rad(val)

func _on_interact_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_interact_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _input(event: InputEvent) -> void:
	if player_nearby and event.is_action_pressed("interact") and not is_moving:
		toggle_state()

func toggle_state() -> void:
	is_moving = true
	door_sound.play()
	# Flip the 'opened' state.
	opened = not opened

	# Determine the target rotation based on the new state.
	var target_rotation_degrees = opened_degrees if opened else closed_degrees

	# Create a Tween for smooth animation.
	var tween = create_tween()

	# Animate the 'rotation:y' property to the target value (in radians).
	tween.tween_property(self, "rotation:y", deg_to_rad(target_rotation_degrees), rotation_duration)\
		 .set_trans(Tween.TRANS_SINE)\
		 .set_ease(Tween.EASE_OUT)

	# After the animation finishes, allow interaction again.
	await tween.finished
	is_moving = false
