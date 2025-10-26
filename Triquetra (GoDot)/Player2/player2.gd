extends CharacterBody2D

const SPEED = 100.0
@onready var anim = $AnimatedSprite2D
@onready var attack_area = $AttackArea
@onready var attack_shape = $AttackArea/CollisionShape2D

var direction := "front"
var state := "idle"

func _ready() -> void:
	# Connect attack area signal if not already
	if not attack_area.body_entered.is_connected(_on_attack_area_body_entered):
		attack_area.body_entered.connect(_on_attack_area_body_entered)
	$AttackArea.monitoring = true
	$AttackArea.visible = true  # optional: hide area in editor if visible


func _physics_process(_delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# --- Slash override ---
	if state == "slash":
		velocity = Vector2.ZERO
		move_and_slide()

		if not anim.is_playing():
			state = "idle"
			attack_area.monitoring = false
		return

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
		velocity = Vector2.ZERO
		anim.play("slash_" + direction)
		_position_attack_area()  # position + flip hitbox
		attack_area.monitoring = true
		return

	# --- Animation logic ---
	if input_vector == Vector2.ZERO:
		state = "idle"
		anim.play("idle_" + direction)
	else:
		state = "walk"
		anim.play("walk_" + direction)


# --- Position & orient attack area in front of player ---
func _position_attack_area() -> void:
	var offset := Vector2.ZERO
	match direction:
		"front":
			offset = Vector2(0, 16)
			attack_shape.rotation_degrees = 0
			attack_shape.scale.x = 1
		"back":
			offset = Vector2(0, -16)
			attack_shape.rotation_degrees = 180
			attack_shape.scale.x = 1
		"left":
			offset = Vector2(-16, 0)
			attack_shape.rotation_degrees = 90
			attack_shape.scale.x = -1  # mirror hitbox horizontally
		"right":
			offset = Vector2(16, 0)
			attack_shape.rotation_degrees = 90
			attack_shape.scale.x = 1
	attack_area.position = offset


# --- When attack hits an enemy ---
func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("NPC") and body.has_method("die"):
		body.die()
