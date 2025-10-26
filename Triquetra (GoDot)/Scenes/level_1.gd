extends Node2D

@onready var fade_anim := $Fade_transition/AnimationPlayer

func _ready() -> void:
	fade_anim.play("fade_out")
	
