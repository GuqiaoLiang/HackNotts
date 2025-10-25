extends Node2D

# 节点引用
@onready var bg: ColorRect = $ColorRect
@onready var logo: TextureRect = $Logo
@onready var title: Label = $Title
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	# === 自动布局 ===
	var screen_size = get_viewport().get_visible_rect().size

	# 背景铺满
	bg.size = screen_size
	bg.color = Color(0.05, 0.05, 0.05)  # 深灰背景

	# 调整 Logo 大小（缩小到原来的 50%）
	logo.scale = Vector2(0.5, 0.5)
	logo.position = screen_size / 2 - logo.size * logo.scale / 2
	logo.position.y -= 80  # 向上挪一点

	# 标题放在 Logo 下方
	title.text = "Triquetra"
	title.modulate = Color.WHITE
	title.position = Vector2(
		(screen_size.x - title.size.x) / 2,
		logo.position.y + logo.size.y * logo.scale.y + 20
	)

	# 进度条放在底部中间
	progress_bar.size = Vector2(screen_size.x * 0.6, 25)
	progress_bar.position = Vector2(
		(screen_size.x - progress_bar.size.x) / 2,
		screen_size.y - 100
	)
	progress_bar.value = 100  # 静态显示满格
