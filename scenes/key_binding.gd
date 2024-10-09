extends Node3D

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_reset_defaults_button_pressed() -> void:
	KeyManager.reset_keymap()
	for item in Utils.get_all_children($CanvasLayer/ControlsContainer):
		if item is KeyBindingButton:
			item.display_current_key()
