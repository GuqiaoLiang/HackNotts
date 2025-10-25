extends CharacterBody2D

const SPEED = 100.0
const GRAVITY = 600.0

@onready var anim = $AnimatedSprite2D

var direction := "front"  # can be "front", "back", "left", "right"
var state := "idle"       # can be "idle", "walk", "slash"

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_anything_pressed():
		print("Pressed something!")

	# Apply gravity (if you have jumping)
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# --- Direction detection ---
	if input_vector.length() > 0:
		# Detect dominant direction
		if abs(input_vector.x) > abs(input_vector.y):
			direction = "right" if input_vector.x > 0 else "left"
		else:
			direction = "back" if input_vector.y < 0 else "front"

	# --- Action input ---
	if Input.is_action_just_pressed("slash"):
		state = "slash"
		anim.play("slash_" + direction)
	elif input_vector == Vector2.ZERO:
		state = "idle"
		anim.play("idle_" + direction)
	else:
		state = "walk"
		anim.play("walk_" + direction)

	# --- Movement ---
	velocity.x = input_vector.x * SPEED
	velocity.y = input_vector.y * SPEED
	print(input_vector)

	move_and_slide()
