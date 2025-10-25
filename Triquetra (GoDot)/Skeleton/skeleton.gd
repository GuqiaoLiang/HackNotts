extends CharacterBody2D

const SPEED = 80.0
@onready var anim = $AnimatedSprite2D

var state := "idle"  # "idle", "run", "react"

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# --- React lock ---
	if state == "react":
		velocity = Vector2.ZERO
		move_and_slide()
		if not anim.is_playing():
			state = "idle"
		return

	# --- Movement ---
	velocity = input_vector * SPEED
	move_and_slide()

	# --- Flip for left/right movement ---
	if input_vector.x != 0:
		anim.flip_h = input_vector.x < 0

	# --- Animation logic ---
	if input_vector == Vector2.ZERO:
		if state != "idle":
			state = "idle"
			anim.play("idle")
	else:
		if state != "walk":
			state = "walk"
			anim.play("walk")
