extends Area3D

@export var locked_sound: AudioStream

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
var player_nearby: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	if locked_sound and audio_player:
		audio_player.stream = locked_sound

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_nearby = false

func _input(event: InputEvent) -> void:
	if player_nearby and event.is_action_pressed("interact"):
		play_locked_sound()

func play_locked_sound() -> void:
	if audio_player and not audio_player.playing:
		audio_player.play()
