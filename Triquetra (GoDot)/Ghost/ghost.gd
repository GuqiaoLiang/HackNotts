extends CharacterBody2D

const SPEED = 120.0
@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED
	move_and_slide()

	# Flip sprite horizontally if moving left/right
	if input_vector.x != 0:
		anim.flip_h = input_vector.x < 0

	# Play animations
	if input_vector == Vector2.ZERO:
		anim.play("idle")
	else:
		anim.play("run")
