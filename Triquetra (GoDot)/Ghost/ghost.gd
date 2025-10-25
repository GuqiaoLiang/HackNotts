extends CharacterBody2D

# === CONFIGURATION ===
const SPEED = 0.0  # Ghost doesn't move freely in this version
const MAX_JUMPS = 3  # How many times it jumps when excited

# === NODES ===
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

# === STATE ===
var state: String = "idle"  # idle, jumping, hit, death
var is_alive: bool = true
var jump_count: int = 0


func _ready() -> void:
	add_to_group("NPC")
	# Detect when player interacts or enters ghost’s area
	interaction_area.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	match state:
		"idle":
			anim.play("idle")

		"jumping":
			# When the current jump animation finishes...
			if not anim.is_playing():
				jump_count += 1
				if jump_count < MAX_JUMPS:
					anim.play("jump")  # Jump again
				else:
					state = "idle"  # Finished excitement jumps
			return

		"hit":
			if not anim.is_playing():
				state = "idle"
			return

		"death":
			return  # Stop everything when dead


# === PLAYER INTERACTION ===
func _on_body_entered(body: Node) -> void:
	# Only react if a player enters the interaction zone
	if body.is_in_group("Player") and state != "jumping":
		_on_player_interacted(body)


func _on_player_interacted(player: Node) -> void:
	# Trigger excitement animation (jump sequence)
	if state != "jumping" and is_alive:
		state = "jumping"
		jump_count = 0
		anim.play("jump")
		# Optional: You could emit a signal here to start a "battle intro"
		# emit_signal("battle_started", self, player)


# === REACTION STATES (for battle system later) ===
func hit() -> void:
	if not is_alive:
		return
	state = "hit"
	anim.play("hit")


func die() -> void:
	if not is_alive:
		return
	is_alive = false
	state = "death"
	anim.play("death")
