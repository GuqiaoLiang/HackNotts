extends Node2D

@onready var logo: TextureRect = $TextureRect

var display_time := 3.0
var fade_time := 1.0

func _ready() -> void:
	logo.modulate.a = 0.0  # 初始透明
	fade_in_logo()

func fade_in_logo() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(logo, "modulate:a", 1.0, fade_time)
	tween.finished.connect(wait_and_fade_out)

func wait_and_fade_out() -> void:
	# 使用 Timer + await 等待显示时间
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = display_time
	timer.one_shot = true
	timer.start()
	await timer.timeout
	fade_out_logo()

func fade_out_logo() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(logo, "modulate:a", 0.0, fade_time)
	tween.finished.connect(_on_fade_out_finished)

func _on_fade_out_finished() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
