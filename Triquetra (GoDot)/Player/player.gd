extends CharacterBody2D

const SPEED = 100.0
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var state = "idle"
var nearby_object = null  # stores what we can interact with

func _ready():
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("interactable"):
		nearby_object = body

func _on_body_exited(body):
	if body == nearby_object:
		nearby_object = null

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED

	# --- Contextual action handling ---
	if nearby_object and nearby_object.has_method("get_action"):
		var action = nearby_object.get_action(self)
		if action == "push":
			state = "push"
			anim.play("push")
		elif action == "pull":
			state = "pull"
			anim.play("pull")
		elif action == "jump":
			state = "jump"
			anim.play("jump")
		else:
			_handle_basic_movement(input_vector)
	else:
		_handle_basic_movement(input_vector)

	move_and_slide()

func _handle_basic_movement(input_vector: Vector2):
	if input_vector == Vector2.ZERO:
		state = "idle"
		anim.play("idle")
	else:
		state = "run"
		anim.play("run")
		if input_vector.x != 0:
			anim.flip_h = input_vector.x < 0
