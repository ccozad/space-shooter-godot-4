extends Node3D

@onready var window_size_option_button: OptionButton = $CanvasLayer/OptionsContainer/WindowSizeOptionButton
@onready var full_screen_button: CheckButton = $CanvasLayer/OptionsContainer/FullScreenButton

var options

func _ready():
	options = OptionsManager.read_options()
	if options.has("full_screen"):
		full_screen_button.set_pressed_no_signal(options.full_screen)
	window_size_option_button.clear()
	var screen_size = DisplayServer.screen_get_size()
	var index = 0
	for size in OptionsManager.window_size_list:
		if size.width <= screen_size.x and size.height <= screen_size.y:
			window_size_option_button.add_item(str(size.width) + " x " + str(size.height))
			var width_matches = options.has("window_width") and size.width == options.window_width
			var height_matches = options.has("window_height") and size.height == options.window_height
			if width_matches and height_matches:
				window_size_option_button.select(index)
			index += 1

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_window_size_option_button_item_selected(index: int) -> void:
	var size = OptionsManager.window_size_list[index]
	options.window_width = size.width
	options.window_height = size.height
	OptionsManager.write_options(options)
	OptionsManager.resize_window()

func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	options.full_screen = toggled_on
	OptionsManager.write_options(options)
	OptionsManager.set_window_mode()
	OptionsManager.resize_window()
