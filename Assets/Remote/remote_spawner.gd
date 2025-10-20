@tool
extends Node3D

@export var time_score = 15.0
@export var click_score: int = 1
@export var debug_value: int = 0

@onready var Remote = get_node("Remote")
@onready var Locations = get_node("Locations").get_children(true)

var current_location_index = 0

## setPosition sets the "Remote" position to one of the set Marker3Ds within "Locations".
func setPosition(index: int) -> void:
	current_location_index = index
	Remote.global_position = Locations[index].global_position
	Remote.global_rotation = Locations[index].global_rotation

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
