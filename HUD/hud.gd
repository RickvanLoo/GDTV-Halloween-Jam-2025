extends Control

@onready var timer_label: Label = $TimerLabel

func _process(_delta: float) -> void:
	var time = GlobalState.time_left

	# Prevent the display from going negative
	if time < 0:
		time = 0

	# --- Format the time to include tenths of a second ---

	# Calculate minutes as an integer
	var minutes = int(time / 60)

	# Use fmod (floating-point modulo) to get the remaining seconds as a float
	var seconds = fmod(time, 60)

	# Format the string.
	# "%02d" formats the minutes to have at least two digits.
	# "%04.1f" formats the seconds to have one decimal place and pads with a
	# leading zero if the seconds value is less than 10 (e.g., "09.5").
	timer_label.text = "%02d:%04.1f" % [minutes, seconds]
