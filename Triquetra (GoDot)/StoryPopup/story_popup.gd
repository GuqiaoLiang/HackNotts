extends CanvasLayer

@onready var bg: TextureRect = $TextureRect
@onready var label: Label = $TextureRect/Label
@onready var next_button: Button = $TextureRect/Button

var story_text: String = "On this haunted Halloween night, the ancient Triquetra symbol awakens. A portal through time shimmers before you, offering a journey across past, present, and future. Uncover hidden treasures on the map and restore balance to the world. Step forward, brave adventurer—destiny awaits."
var current_text: String = ""
var char_index: int = 0
var typing_speed: float = 0.02  # 每个字符的显示间隔（秒）
var is_typing: bool = false

func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size

	# 背景设置
	bg.set_size(screen_size)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.visible = true
	bg.modulate.a = 0.0

	# 渐入动画
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# 背景渐入后开始打字效果
	tween.tween_callback(start_typing)

	# Label 设置
	label.text = ""  # 开始时清空文本
	label.visible = true
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# 设置文字颜色为黑色
	label.add_theme_color_override("font_color", Color.BLACK)
	
	# 按钮初始不可用，等待打字完成
	next_button.disabled = true
	next_button.pressed.connect(_on_next_pressed)

func start_typing() -> void:
	is_typing = true
	char_index = 0
	current_text = ""
	label.text = current_text
	
	# 开始打字效果
	var timer = get_tree().create_timer(typing_speed)
	timer.timeout.connect(_type_next_character)

func _type_next_character() -> void:
	if char_index < story_text.length():
		current_text += story_text[char_index]
		label.text = current_text
		char_index += 1
		
		# 继续下一个字符
		var timer = get_tree().create_timer(typing_speed)
		timer.timeout.connect(_type_next_character)
	else:
		# 打字完成，启用按钮
		is_typing = false
		next_button.disabled = false

func _on_next_pressed() -> void:
	# 如果还在打字中，直接完成所有文字
	if is_typing:
		# 取消所有待处理的计时器
		get_tree().create_timer(0).timeout.connect(func(): pass)  # 空回调以取消之前的计时器
		
		# 立即显示所有文字
		label.text = story_text
		is_typing = false
		next_button.disabled = false
		return
	
	# 正常流程：淡出并切换到地图场景
	var tween = create_tween()
	tween.tween_property(bg, "modulate:a", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_go_to_map)

func _go_to_map():
	get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")
