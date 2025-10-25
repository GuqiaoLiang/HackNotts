extends TextureRect

# 显示时间（秒）
var display_time := 3.0
var fade_time := 1.0

# 动态进度变量（0~1）
var progress := 0.0
var progress_speed := 0.5  # 每秒增长 0.5

# 开机图表节点（ProgressBar）
@onready var progress_bar := $ProgressBar  # 如果你在 TextureRect 下添加了 ProgressBar

func _ready() -> void:
	# 初始透明
	modulate.a = 0
	# 渐入动画
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_time)

func _process(delta: float) -> void:
	# 动态增加图表进度
	if progress < 1.0:
		progress += progress_speed * delta
		progress_bar.value = progress * 100  # ProgressBar 范围 0~100
	else:
		# 进度完成后渐出
		var tween := get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.0, fade_time)
		tween.finished.connect(Callable(self, "_on_fade_out_finished"))  # ✅ Godot 4 写法
		set_process(false)  # 停止 _process

func _on_fade_out_finished() -> void:
	# 切换到主菜单
	get_tree().change_scene("res://MainMenu.tscn")
