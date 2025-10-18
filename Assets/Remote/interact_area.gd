extends Area3D

signal remote_interacted

var player_nearby: bool = false

@onready var spark_sound: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _input(event: InputEvent) -> void:
	if player_nearby and event.is_action_pressed("interact"):
		spark_sound.play()
		emit_signal("remote_interacted")
