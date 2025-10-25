extends CharacterBody2D

const SPEED = 0.0  # ghost doesn't move normally
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var state = "idle"
var is_alive = true
var jump_count = 0
const MAX_JUMPS = 3  # number of excited jumps after interaction

func _ready():
	add_to_group("NPC")
	interaction_area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	match state:
		"idle":
			anim.play("idle")

		"jumping":
			if not anim.is_playing():
				jump_count += 1
				if jump_count < MAX_JUMPS:
					anim.play("jump")  # jump again
				else:
					state = "idle"  # finished jumping
			return

		"hit":
			if not anim.is_playing():
				state = "idle"
			return

		"death":
			return

func _on_body_entered(body):
	if body.is_in_group("Player"):
		_on_player_interacted(body)

func _on_player_interacted(player):
	if state != "jumping":
		state = "jumping"
		jump_count = 0
		anim.play("jump")
