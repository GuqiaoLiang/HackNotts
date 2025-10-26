extends CharacterBody2D

# === CONFIG ===
const MOVE_SPEED: float = 50.0
const STOP_DISTANCE: float = 50.0  # 靠近后停止的距离

# === REFERENCES ===
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubble: Panel = $Bubble
@onready var bubble_label: Label = $Bubble/Label
var player: Node2D

# === STATE ===
var is_talking: bool = false
var reached_player: bool = false

func _ready() -> void:
	add_to_group("NPC")

	bubble.visible = false
	bubble_label.text = ""
	
	# 确保气泡有合适的初始尺寸
	bubble.scale = Vector2(0.5, 0.5)
	
	# 检查动画名称并打印可用的动画
	print("可用的动画: ", anim.sprite_frames.get_animation_names())
	
	# 立即尝试获取玩家引用
	_find_player()

func _find_player() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		# 如果没找到，稍后重试
		await get_tree().create_timer(0.5).timeout
		_find_player()

# === MAIN LOOP ===
func _physics_process(_delta: float) -> void:
	if is_talking:
		return
		
	if player == null:
		_find_player()
		return

	var dir: Vector2 = player.global_position - global_position
	var distance: float = dir.length()

	if distance > STOP_DISTANCE:
		velocity = dir.normalized() * MOVE_SPEED
		move_and_slide()
		# 使用存在的动画名称 - 尝试常见的名称
		if anim.sprite_frames.has_animation("run"):
			anim.play("run")
		elif anim.sprite_frames.has_animation("walk"):
			anim.play("walk")
		elif anim.sprite_frames.has_animation("move"):
			anim.play("move")
		else:
			# 如果有默认动画，使用它
			var animations = anim.sprite_frames.get_animation_names()
			if animations.size() > 0:
				anim.play(animations[0])
				_start_dialogue()
	else:
		velocity = Vector2.ZERO
		if not reached_player:
			reached_player = true
			_start_dialogue()

# === DIALOGUE LOGIC ===
func _start_dialogue() -> void:
	is_talking = true
	# 使用存在的动画名称 - 尝试常见的名称
	if anim.sprite_frames.has_animation("idle"):
		anim.play("idle")
	else:
		# 如果有默认动画，使用它
		var animations = anim.sprite_frames.get_animation_names()
		if animations.size() > 0:
			anim.play(animations[0])
	
	print("开始对话")  # 调试信息

	# 确保气泡在显示前有正确的设置
	bubble.visible = true
	bubble.modulate.a = 1.0
	bubble.scale = Vector2(0.5, 0.5)  # 重置缩放
	
	# 设置文本
	bubble_label.text = "Beware, Time Traveller..."
	bubble_label.add_theme_font_size_override("font_size", 16)  # 增加字体大小
	
	# 确保气泡在正确层级
	bubble.z_index = 100  # 确保气泡在最前面
	
	# 将气泡位置设置为屏幕上的固定位置，而不是相对于鬼魂
	var viewport_size = get_viewport().get_visible_rect().size
	bubble.position = Vector2(
		viewport_size.x / 2 - bubble.size.x * bubble.scale.x / 2,
		viewport_size.y / 3
	)
	
	# 打印调试信息
	print("气泡可见性: ", bubble.visible)
	print("气泡位置: ", bubble.position)
	print("气泡尺寸: ", bubble.size)
	print("气泡缩放: ", bubble.scale)
	print("视口尺寸: ", viewport_size)
	
	# 启动对话序列
	_start_dialogue_sequence()

func _start_dialogue_sequence() -> void:
	# 1.5秒后显示第二句
	await get_tree().create_timer(1.5).timeout
	bubble_label.text = "You don't belong to this time..."
	
	# 2秒后结束对话
	await get_tree().create_timer(2.0).timeout
	_end_dialogue()

func _end_dialogue() -> void:
	print("结束对话")  # 调试信息
	
	var tween := create_tween()
	tween.tween_property(bubble, "modulate:a", 0.0, 0.5)
	await tween.finished
	bubble.visible = false
	is_talking = false
	
	# 鬼魂退场 - 使用移动动画
	if anim.sprite_frames.has_animation("run"):
		anim.play("run")
	elif anim.sprite_frames.has_animation("walk"):
		anim.play("walk")
	elif anim.sprite_frames.has_animation("move"):
		anim.play("move")
	else:
		# 如果有默认动画，使用它
		var animations = anim.sprite_frames.get_animation_names()
		if animations.size() > 0:
			anim.play(animations[0])
			
	var retreat_target := global_position + Vector2(0, -200)
	var retreat_tween := create_tween()
	retreat_tween.tween_property(self, "global_position", retreat_target, 3.0).set_trans(Tween.TRANS_SINE)
	retreat_tween.tween_callback(queue_free)  # 退场后删除自己
