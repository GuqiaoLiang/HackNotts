extends CharacterBody2D

const SPEED = 100.0
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
const BGM_PATH := "res://Songs/Halloween.mp3" 

# === LEVEL CHANGE CONFIG ===
const NEXT_LEVEL_PATH := "res://Scenes/Level_2.tscn"  # 目标关卡路径
const TRANSITION_POINT := Vector2(218, -229)          # 目标坐标
const TRIGGER_RADIUS := 20                       # 触发距离范围

# === STATE ===
var state: String = "idle"
var nearby_object: Node = null
var level_changing: bool = false

# === TIMER ===
@onready var debug_timer := Timer.new()
@onready var bgm_player := AudioStreamPlayer.new()  # 🎵 播放器

func _ready() -> void:
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

	# 创建一个定时器，每隔 1 秒打印坐标
	debug_timer.wait_time = 1.0
	debug_timer.autostart = true
	debug_timer.timeout.connect(_on_debug_timer_timeout)
	add_child(debug_timer)
	_play_bgm()
	
func _play_bgm() -> void:
	var bgm := load(BGM_PATH)
	if bgm:
		bgm_player.stream = bgm
		bgm_player.volume_db = -5    # 调整音量（0 是最大音量，负数是降低）
		bgm_player.autoplay = false
		add_child(bgm_player)
		bgm_player.play()
		print("🎶 BGM started playing:", BGM_PATH)
	else:
		push_warning("⚠️ Failed to load BGM at " + BGM_PATH)



func _on_debug_timer_timeout() -> void:
	var distance := global_position.distance_to(TRANSITION_POINT)
	print("📍 [DEBUG] Player position:", global_position, " | Distance to target:", distance)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("interactable"):
		nearby_object = body

func _on_body_exited(body: Node) -> void:
	if body == nearby_object:
		nearby_object = null

func _physics_process(_delta: float) -> void:
	if level_changing:
		return

	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED
	move_and_slide()

	# 检查是否到达 Level 切换点
	var distance := global_position.distance_to(TRANSITION_POINT)
	if distance < TRIGGER_RADIUS:
		print("✅ Player reached target area — starting level transition!")
		_change_level()

	# 动画状态控制
	if input_vector == Vector2.ZERO:
		state = "idle"
		anim.play("idle")
	else:
		state = "run"
		anim.play("run")
		if input_vector.x != 0:
			anim.flip_h = input_vector.x < 0

# === LEVEL CHANGE LOGIC ===
func _change_level() -> void:
	if level_changing:
		return
	level_changing = true

	print("🚪 Level1 → Level2 Transition Triggered!")

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	print("🌌 Scene changing to Level_2 now!")
	get_tree().change_scene_to_file(NEXT_LEVEL_PATH)
