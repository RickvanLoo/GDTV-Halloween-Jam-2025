extends Control

@export var time_gradient: Gradient

@onready var timer_label: Label = $TimerLabel
@onready var score_label: Label = $ScoreLabel

func _process(_delta: float) -> void:
	var time = GlobalState.time_left

	# Prevent the display from going negative
	if time < 0:
		time = 0

# --- Update color based on the current time ---
	if time_gradient:
		# Calculate the progress from 0.0 (full time) to 1.0 (time is up).
		# This calculation runs every frame, so it immediately reacts to time changes.
		var progress = clamp(1.0 - (time / GlobalState.max_time), 0.0, 1.0)

		# Sample the gradient and apply the color to the label's font.
		timer_label.add_theme_color_override("font_color", time_gradient.sample(progress))

	# --- Format the time to include tenths of a second ---
	var minutes = int(time / 60)
	var seconds = fmod(time, 60)
	timer_label.text = "%02d:%04.1f" % [minutes, seconds]

	score_label.text = "Score: %d" % GlobalState.score
