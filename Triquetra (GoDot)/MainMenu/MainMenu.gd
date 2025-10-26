extends Node2D

var button_type = null

func _ready() -> void:
	pass

func _process(delta: float):
	pass
	

func _on_start_pressed() -> void:
	button_type = "start"
	$Fade_Transition.show()
	$Fade_Transition/FadeTimer.start()
	$Fade_Transition/AnimationPlayer.play("fade_in")


func _on_quit_pressed() -> void:
	button_type = "quit"
	$Fade_Transition.show()
	$Fade_Transition/FadeTimer.start()
	$Fade_Transition/AnimationPlayer.play("fade_out")


func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")
	
	elif button_type == "quit":
		get_tree().quit()
