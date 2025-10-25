extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var state = "idle"
var player_nearby = false

func _ready():
	# Connect the signals for interaction detection
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	anim.play("idle")

func _physics_process(delta: float) -> void:
	match state:
		"idle":
			anim.play("idle")
		"fly":
			anim.play("fly")
		"react":
			if not anim.is_playing():
				state = "idle"

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
		# Optional: trigger a fly-away animation afterward
		await anim.animation_finished
		state = "fly"
