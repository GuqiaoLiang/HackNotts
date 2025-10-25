extends Node2D

@onready var bg: TextureRect = $TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var bgm = $bgm

@export var bgm_path := "res://Songs/medieval.mp3"
func _ready() -> void:
	var stream = load(bgm_path)
	if stream:
		bgm.stream = stream
		bgm.volume_db = -6
		bgm.autoplay = true
		bgm.play()
	# 背景铺满屏幕
	var screen_size = get_viewport().get_visible_rect().size
	bg.size = screen_size
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

	# 模拟加载进度
	simulate_loading()


func simulate_loading():
	var tween = create_tween()
	tween.tween_method(update_progress, 0, 100, 3.0)


func update_progress(value: float):
	progress_bar.value = value
	if value >= 100:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
