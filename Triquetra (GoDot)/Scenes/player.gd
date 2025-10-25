extends CharacterBody2D

const SPEED = 100.0
@onready var anim = $AnimatedSprite2D

var state = "idle"  # idle, run, jump, pull, push

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED
	move_and_slide()
	
	# --- Action handling ---
	if Input.is_action_just_pressed("jump"):
		state = "jump"
		anim.play("jump")

	elif Input.is_action_pressed("pull"):
		state = "pull"
		anim.play("pull")

	elif Input.is_action_pressed("push"):
		state = "push"
		anim.play("push")

	# --- Movement handling ---
	elif input_vector == Vector2.ZERO:
		state = "idle"
		anim.play("idle")

	else:
		state = "run"
		anim.play("run")

		# Optional: flip horizontally
		if input_vector.x != 0:
			anim.flip_h = input_vector.x < 0
