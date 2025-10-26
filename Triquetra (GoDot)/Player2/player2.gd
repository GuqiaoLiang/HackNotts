extends CharacterBody2D

const SPEED = 100.0
@onready var anim = $AnimatedSprite2D

var direction := "front"
var state := "idle"

func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# --- Slash override ---
	if state == "slash":
		# Stop all movement while slashing
		velocity = Vector2.ZERO
		move_and_slide()

		# Wait for slash animation to finish
		if not anim.is_playing():
			state = "idle"
		return  # skip rest of code while slashing

	# --- Movement ---
	velocity = input_vector * SPEED
	move_and_slide()

	# --- Direction detection ---
	if input_vector.length() > 0:
		if abs(input_vector.x) > abs(input_vector.y):
			direction = "right" if input_vector.x > 0 else "left"
		else:
			direction = "back" if input_vector.y < 0 else "front"

	# --- Slash action ---
	if Input.is_action_just_pressed("slash"):
		state = "slash"
		velocity = Vector2.ZERO   # stop moving instantly
		anim.play("slash_" + direction)
		return  # stop here this frame

	# --- Animation logic ---
	if input_vector == Vector2.ZERO:
		state = "idle"
		anim.play("idle_" + direction)
	else:
		state = "walk"
		anim.play("walk_" + direction)
