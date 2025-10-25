extends CharacterBody2D

const SPEED = 40.0
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var state := "idle"  # "idle", "walk", "react"
var player_nearby := false

func _ready():
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	anim.play("idle")

func _physics_process(delta: float) -> void:
	match state:
		"idle":
			anim.play("idle")
		"walk":
			anim.play("walk")
		"react":
			velocity = Vector2.ZERO
			move_and_slide()
			if not anim.is_playing():
				state = "idle"
			return

	move_and_slide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		react_to_player()

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false

func react_to_player():
	if state != "react":
		state = "react"
		anim.play("react")
