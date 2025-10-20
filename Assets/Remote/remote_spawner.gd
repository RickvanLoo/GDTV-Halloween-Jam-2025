@tool
extends Node3D

@export var time_score = 15.0
@export var click_score: int = 1
@export var debug_value: int = 0

@onready var Remote = get_node("Remote/RigidBody3D")
@onready var Locations = get_node("Locations").get_children(true)
@onready var spark_sound: AudioStreamPlayer3D = $Remote/RigidBody3D/AudioStreamPlayer3D

var current_location_index = 0

## setPosition sets the "Remote" position to one of the set Marker3Ds within "Locations".
func setPosition(index: int) -> void:
	print("Setting to "+str(index)+" name: "+str(Locations[index].name))
	
	
	current_location_index = index
	# Wait for the scene tree to process
	await get_tree().process_frame

	Remote.global_position = Locations[index].global_position
	Remote.global_rotation = Locations[index].global_rotation
	spark_sound.play()

## getSemiRandomIndex returns a "random" index of the locations, but makes sure it's different than the previous.
func getSemiRandomLocation() -> int:
	var random_index = current_location_index
	while random_index == current_location_index:
		random_index = randi_range(0, Locations.size()-1)
	
	return random_index

func _ready():
	if debug_value > 0:
		setPosition(debug_value)
	else:	
		setPosition(0) # Always start at location 0
	
func _on_interact_area_remote_interacted() -> void:
	setPosition(getSemiRandomLocation())
	GlobalState.add_time(time_score)
	GlobalState.add_score(click_score)
