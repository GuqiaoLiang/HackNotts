extends CharacterBody2D

# === 可调参数 ===
@export var move_speed := 60.0
@export var stop_distance := 100.0  # 鬼与玩家停下的距离
@export var fade_in_time := 1.2
@export var fade_out_time := 1.5
@export var float_amplitude := 8.0
@export var float_speed := 2.0
@export var line_text := "You shouldn't be here..."  # 鬼说的话

# === 节点引用 ===
@onready var anim = $AnimatedSprite2D
@onready var bubble = $Bubble
@onready var label = $Bubble/Label

# === 内部变量 ===
var appeared := false
var speaking := false
var floating_time := 0.0
var origin_y := 0.0
var player: CharacterBody2D

func _ready() -> void:
	# 立即获取玩家引用，不要等到淡入完成
	_find_player()
	
	# 初始状态
	anim.modulate.a = 0.0
	bubble.visible = false
	label.visible = false
	label.add_theme_font_size_override("font_size", 11)
	
	# 调整气泡大小和位置 - 这是关键修改
	bubble.scale = Vector2(0.2, 0.2)  # 从0.45改为0.2
	bubble.position = Vector2(0, -35)  # 从-45改为-35，使气泡更接近鬼魂
	
	origin_y = position.y
	anim.play("idle")

	# 淡入出现
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 1.0, fade_in_time)
	tween.tween_callback(func(): 
		appeared = true
	)

func _find_player():
	# 获取玩家引用
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]
		print("找到玩家: ", player.name)
	else:
		print("未找到玩家，请确保玩家在'Player'组中")
		# 如果没找到，设置一个定时器稍后重试
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(_find_player)

func _physics_process(delta: float) -> void:
	if not appeared or speaking:
		return

	# 漂浮
	floating_time += delta * float_speed
	position.y = origin_y + sin(floating_time) * float_amplitude

	# 如果玩家引用丢失，尝试重新获取
	if not player:
		_find_player()
		return

	var dir = (player.global_position - global_position)
	var distance = dir.length()

	if distance > stop_distance:
		# 向玩家移动
		velocity = dir.normalized() * move_speed
		move_and_slide()
		anim.play("run")
		
		# 修正方向：确保鬼魂朝向移动方向
		if velocity.x != 0:
			anim.flip_h = velocity.x < 0
	else:
		# 到达目标点，开始说话
		velocity = Vector2.ZERO
		if not speaking:
			speak_to_player()

func speak_to_player():
	speaking = true
	anim.play("idle")

	# 显示对白气泡
	bubble.visible = true
	label.visible = true
	label.text = line_text
	bubble.modulate.a = 1.0
	label.modulate.a = 1.0

	# 2 秒后淡出气泡
	var tween = create_tween()
	tween.tween_property(bubble, "modulate:a", 0.0, 2.0).set_delay(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 2.0).set_delay(2.0)
	tween.tween_callback(func():
		bubble.visible = false
		label.visible = false
		_fade_out_and_leave()
	)

func _fade_out_and_leave():
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 0.0, fade_out_time)
	tween.tween_callback(func():
		queue_free()  # 鬼淡出后消失
	)
