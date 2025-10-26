extends CharacterBody2D

# === CONFIGURATION ===
const SPEED = 0.0
const MAX_JUMPS = 3
const JUMP_DELAY = 0.4

# === NODES ===
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var jump_timer = $JumpTimer

# === STATE ===
var state: String = "idle"     # idle, jumping, hit, death
var is_alive: bool = true
var jump_count: int = 0


func _ready() -> void:
	add_to_group("NPC")

	interaction_area.body_entered.connect(_on_body_entered)
	jump_timer.timeout.connect(_on_jump_timer_timeout)


func _physics_process(_delta: float) -> void:
	if not is_alive:
		return

	match state:
		"idle":
			anim.play("idle")

		"jumping":
			return

		"hit":
			if not anim.is_playing():
				state = "idle"
			return

		"death":
			return  # stop updates on death


# === PLAYER INTERACTION ===
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and state != "jumping":
		_on_player_interacted(body)


func _on_player_interacted(_player: Node) -> void:
	if state != "jumping" and is_alive:
		state = "jumping"
		jump_count = 0
		anim.play("jump")
		jump_timer.start(JUMP_DELAY)


# === TIMER CALLBACK ===
func _on_jump_timer_timeout() -> void:
	if state != "jumping" or not is_alive:
		return

	if not anim.is_playing():
		jump_count += 1
		if jump_count < MAX_JUMPS:
			anim.play("jump")
			jump_timer.start(JUMP_DELAY)
		else:
			state = "idle"
			anim.play("idle")


# === REACTION STATES ===
func hit() -> void:
	if not is_alive:
		return
	state = "hit"
	anim.play("hit")

	# Flash red briefly
	anim.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.2).timeout
	anim.modulate = Color(1, 1, 1)


func die() -> void:
	if not is_alive:
		return
	is_alive = false
	state = "death"

	# Stop all actions
	jump_timer.stop()
	interaction_area.monitoring = false

	anim.play("death")

	# Optional: fade out smoothly after death animation
	await anim.animation_finished
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()
