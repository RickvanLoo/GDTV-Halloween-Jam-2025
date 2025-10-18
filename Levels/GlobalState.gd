extends Node

@export var starting_time = 10.0

# The starting time in seconds
var time_left: float = 0.0
var timer_running: bool = false

# This function runs every frame
func _process(delta: float) -> void:
	if timer_running:
		time_left -= delta
		
		if time_left <= 0:
			time_left = 0
			timer_running = false
			
			game_over()

# A function to add time to the timer, callable from anywhere
func add_time(amount: float) -> void:
	time_left += amount

func game_over() -> void:
	get_tree().change_scene_to_file("res://Levels/Menu/game_over.tscn")
	
func start_game() -> void:
	get_tree().change_scene_to_file("res://Levels/Main/Level0.tscn")
	
func start_menu() -> void:
	get_tree().change_scene_to_file("res://Levels/Menu/start_menu.tscn")

func reset_timer() -> void:
	time_left = starting_time
	timer_running = true
