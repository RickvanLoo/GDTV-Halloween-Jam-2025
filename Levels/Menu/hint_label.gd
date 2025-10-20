extends Label

@onready var timer: Timer = $"../Timer"

# An array to hold all your possible hint strings.
var hints = [
	"That remote is playing hide-and-seek. And it's winning.",
	"The remote doesn't just change the channel... it changes its location.",
	"Some say it's not the remote that moves, but the world that shifts around it.",
	"Quick! The ghost in the TV is trying to escape!\nBetter keep going after that remote!",
	"This cursed object will never know rest.\nNeither will you until you find it each time it vanishes.",
	"The remote isn't just teleporting; it's mapping the house's ley lines.\nYou must interrupt the ritual, over and over.",
	"You found it once, but the haunting isn't over. \nIt's already moved on. Find it again!",
	"Don't get comfortable. \nThe moment you find it is just the beginning of the next search. Go!",
	"Its journey through the veil is endless. \nYour hunt has just begun... again."
]

# Spooky colors for the text to fade into.
var spooky_colors = [Color.ORANGE, Color.PALE_GREEN, Color.PURPLE]

# **NEW**: Variable to store the index of the currently displayed hint.
var current_hint_index = -1

func _ready():
	# Connect the timer's "timeout" signal to our function.
	timer.timeout.connect(start_hint_change_effect)

	# Set an initial hint without an animation.
	# We call the function directly to ensure the logic is handled properly from the start.
	change_hint_text()
	modulate = Color.ORANGE# Ensure it's fully visible at the start.

func start_hint_change_effect():
	# This function remains the same. It handles the animation.
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(change_hint_text)
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func change_hint_text():
	# **MODIFIED**: This function now ensures a new hint is picked.

	# 1. Pick a new random index.
	var new_hint_index = randi() % hints.size()

	# 2. If the new index is the same as the current one, pick again until it's different.
	#    This loop is crucial to prevent repeats.
	while new_hint_index == current_hint_index:
		new_hint_index = randi() % hints.size()

	# 3. Update the current index to the new one.
	current_hint_index = new_hint_index

	# 4. Set the text to the new, unique hint.
	text = hints[current_hint_index]

	# Pick a new random spooky color for the text.
	modulate = spooky_colors.pick_random()
	modulate.a = 0.0 # Set alpha to 0 so it's ready to fade in.
