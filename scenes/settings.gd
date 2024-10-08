extends Node3D

@onready var window_size_option_button: OptionButton = $CanvasLayer/OptionsContainer/WindowSizeOptionButton
@onready var full_screen_button: CheckButton = $CanvasLayer/OptionsContainer/FullScreenButton
@onready var gamma_label: Label = $CanvasLayer/OptionsContainer/GammaLabel
@onready var gamma_slider: HSlider = $CanvasLayer/OptionsContainer/GammaSlider
@onready var asteroid: Enemy = $asteroid
@onready var enemy_ship: Enemy = $enemy_ship
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var master_volume_slider: HSlider = $CanvasLayer/OptionsContainer/MasterVolumeSlider
@onready var music_volume_slider: HSlider = $CanvasLayer/OptionsContainer/MusicVolumeSlider
@onready var sound_effects_volume_slider: HSlider = $CanvasLayer/OptionsContainer/SoundEffectsVolumeSlider

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
	gamma_slider.value = options.tonemap_exposure if options.has("tonemap_exposure") else 1.0
	master_volume_slider.value = options.master_volume if options.has("master_volume") else 1.0
	music_volume_slider.value = options.music_volume if options.has("music_volume") else 1.0
	sound_effects_volume_slider.value = options.sound_effects_volume if options.has("sound_effects_volume") else 1.0
	spawn_asteroid()
	spawn_enemy_ship()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_key_binding_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/key_binding.tscn")

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

func _on_gamma_slider_value_changed(value: float) -> void:
	options.tonemap_exposure = gamma_slider.value
	OptionsManager.write_options(options)
	world_environment.environment.tonemap_exposure = options.tonemap_exposure

func _on_master_volume_slider_value_changed(value: float) -> void:
	options.master_volume = value
	OptionsManager.write_options(options)
	SoundManager.set_master_volume(value)

func _on_music_volume_slider_value_changed(value: float) -> void:
	options.music_volume = value
	OptionsManager.write_options(options)
	SoundManager.set_music_volume(value)

func _on_sound_effects_volume_slider_value_changed(value: float) -> void:
	options.sound_effects_volume = value
	OptionsManager.write_options(options)
	SoundManager.set_sound_effects_volume(value)

func spawn_asteroid():
	var spawn = {
		"hit_points": 20.0,
		"coords": Vector3.ZERO,
		"scale": Vector3(5,5,5),
		"direction": Vector3.ZERO,
		"rotation": Utils.get_random_vector3_in_range(0.1, 1.0)
	}
	asteroid.init(self, spawn, [])

func spawn_enemy_ship():
	var spawn = {
		"hit_points": 20.0,
		"coords": Vector3.ZERO,
		"scale": Vector3(5,5,5),
		"direction": Vector3.ZERO,
		"rotation": Vector3(0, 0, 0.8)
	}
	enemy_ship.init(self, spawn, [])
