extends Node3D

@onready var camera: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.set_boundary(
		$"Boundary/LeftWall".position.x,
		$"Boundary/RightWall".position.x,
		$"Boundary/TopWall".position.z,
		$"Boundary/BottomWall".position.z
	)
	GameManager.set_camera(camera)
	GameManager.spawn_stars(self)
	GameManager.release_mouse()
	SoundManager.fade_in_intro_song()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameManager.process_background(self, delta)


func _on_start_button_pressed() -> void:
	SoundManager.fade_out_intro_song();
	get_tree().change_scene_to_file("res://main.tscn")


func _on_exit_button_pressed() -> void:
	SoundManager.fade_out_intro_song();
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	SoundManager.fade_out_intro_song();
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
