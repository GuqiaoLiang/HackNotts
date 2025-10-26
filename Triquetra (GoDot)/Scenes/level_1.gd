extends Node2D

@onready var fade_anim := $Fade_transition/AnimationPlayer
@onready var jax_node := $Jax   # Replace this with your actual path if Jax is nested deeper

func _ready() -> void:
	fade_anim.play("fade_out")

	# --- Load and set Dialogic style ---
	Dialogic.Styles.change_style("textbubble")  # ensures the textbubble layout is used

	# --- Start your timeline ---
	var layout := Dialogic.start("timeline")  # starts the timeline and creates layout layers

	# --- Wait one frame to ensure layout and textbubble layer are ready ---
	await get_tree().process_frame

	# --- Register Jax as a character for the TextBubble ---
	var jax_char: DialogicCharacter = preload("res://dialogic/characters/Jax.dch")

	# Find the textbubble layer (so we can attach the character bubble)
	var bubble_layer := Dialogic.Styles.get_first_node_in_layout("TextBubble")
	if bubble_layer and bubble_layer.has_method("register_character"):
		bubble_layer.register_character(jax_char, jax_node)
	else:
		push_warning("Could not register Jax: TextBubble layer not found or invalid.")
