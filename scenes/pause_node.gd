extends Node


# Called when the node enters the scene tree for the first time.
func _input(_event):
	if Input.is_action_just_pressed("resume_game"):
		if get_tree().paused:
			GameManager.clear_pause_environment()
			get_tree().paused = false
