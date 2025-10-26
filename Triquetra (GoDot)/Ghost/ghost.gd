extends CharacterBody2D

# === CONFIGURATION ===
const SPEED = 0.0              # Ghost doesn't move freely in this version
const MAX_JUMPS = 3            # How many times it jumps when excited
const JUMP_DELAY = 0.4         # Delay between jumps (seconds)

# === NODES ===
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var jump_timer = $JumpTimer   # Timer node added in the scene

# === STATE ===
var state: String = "idle"     # idle, jumping, hit, death
var is_alive: bool = true
var jump_count: int = 0


func _ready() -> void:
	add_to_group("NPC")

	# Connect the InteractionArea signal
	interaction_area.body_entered.connect(_on_body_entered)

	# Connect the Timer signal (so we know when to do the next jump)
	jump_timer.timeout.connect(_on_jump_timer_timeout)


func _physics_process(_delta: float) -> void:
	if not is_alive:
		return

	match state:
		"idle":
			anim.play("idle")

		"jumping":
			# The jumping logic is handled by the timer callback
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


func _on_player_interacted(_player: Node) -> void:
	# Trigger excitement animation (jump sequence)
	if state != "jumping" and is_alive:
		state = "jumping"
		jump_count = 0
		anim.play("jump")
		jump_timer.start(JUMP_DELAY)  # start delay before next jump


# === TIMER CALLBACK ===
func _on_jump_timer_timeout() -> void:
	if state != "jumping" or not is_alive:
		return

	# If animation has finished and jumps remain
	if not anim.is_playing():
		jump_count += 1

		if jump_count < MAX_JUMPS:
			anim.play("jump")
			jump_timer.start(JUMP_DELAY)  # delay next jump
		else:
			state = "idle"
			anim.play("idle")


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
