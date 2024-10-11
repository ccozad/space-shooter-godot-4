extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OptionsManager.set_window_mode()
	OptionsManager.resize_window()
	GameManager.release_mouse()
	animation_player.play("author_fade_in_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
