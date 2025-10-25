extends Node2D

@onready var btn_play = $menu_box/btn_play
@onready var btn_quit = $menu_box/btn_quit
@onready var bgm = $bgm
@onready var anim = $anim

@export var bgm_path := "res://Songs/medieval.mp3"

func _ready():
	# 背景音乐
	var stream = load(bgm_path)
	if stream:
		bgm.stream = stream
		bgm.volume_db = -6
		bgm.autoplay = true
		bgm.play()

	# 连接按钮
	btn_play.connect("pressed", Callable(self, "_on_play_pressed"))
	btn_quit.connect("pressed", Callable(self, "_on_quit_pressed"))

	# 播放入场动画（可选）
	if anim.has_animation("intro"):
		anim.play("intro")

func _on_play_pressed():
	# 播放点击动画
	if anim.has_animation("fade_out"):
		anim.play("fade_out")
		anim.connect("animation_finished", Callable(self, "_on_anim_finished"))
	else:
		_start_game()

func _on_quit_pressed():
	get_tree().quit()

func _on_anim_finished(anim_name):
	if anim_name == "fade_out":
		_start_game()

func _start_game():
	# 改成你的游戏主场景路径，例如：res://Scenes/level1.tscn
	get_tree().change_scene_to_file("res://StoryPopup/StoryPopup.tscn")
