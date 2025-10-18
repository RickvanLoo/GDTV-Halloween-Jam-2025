extends Node3D

@export var pattern: String = "mmamammmmammamamaaamammma"
@export var speed: float = 10.0  # frames per second
@export var max_energy: float = 10.0  # maximum brightness

var _time := 0.0
var _frame := 0
@onready var light = get_node("Light")
# super hacky wtf pls fix
@onready var emissive_screen = get_parent().get_node("StaticBody3D/MeshCollection/Cube_002_15/EmissiveScreen")
@onready var audio_player = get_node("AudioStreamPlayer3D")

var playback: AudioStreamGeneratorPlayback
var current_flicker_offset_db: float = 0.0

# Adjust this to control the noise volume
@export var volume_db: float = -60.0
@export var flicker_intensity_db: float = 5.0


func _ready():
	# Check if the AudioStreamPlayer node is assigned
	if not audio_player:
		push_error("AudioStreamPlayer node not assigned in the inspector.")
		return

	# Start playing the stream
	audio_player.play()
	
		# Get the playback object from the assigned AudioStreamPlayer
	playback = audio_player.get_stream_playback()
	
	if not playback:
		push_error("The stream on the assigned AudioStreamPlayer is not an AudioStreamGenerator.")
		return


func _process(delta: float) -> void:
	if pattern.is_empty():
		return
		
	var LightValue := 0

	_time += delta
	if _time >= 1.0 / speed:
		_time = 0.0
		_frame = (_frame + 1) % pattern.length()
		var char = pattern[_frame]
		var value = clamp(char.unicode_at(0) - 'a'.unicode_at(0), 0, 25)
		
		LightValue =  max_energy * (value / 25.0)
		light.light_energy = LightValue
		emissive_screen.get_surface_override_material(0).emission_energy = LightValue
		
		
		
	if not playback:
		return
	
	# Calculate a new random volume offset
	if LightValue > 0:
		current_flicker_offset_db = flicker_intensity_db
	else:
		current_flicker_offset_db = -flicker_intensity_db

		# Convert volume from decibels to linear scale
	var volume_linear = db_to_linear(volume_db+current_flicker_offset_db)
	
	
	var frames_to_fill = playback.get_frames_available()
	# Generate and push one frame at a time
	for i in range(frames_to_fill):
		# Generate a random sample using a normal distribution for white noise
		var noise_sample = randfn(0, 1)

		# Create a stereo frame (same sample for left and right channels)
		# and apply the volume

		var frame = Vector2(noise_sample, noise_sample) * volume_linear

		# Push the frame to the audio buffer
		playback.push_frame(frame)
	
