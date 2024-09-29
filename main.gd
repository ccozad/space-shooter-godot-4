extends Node3D

const SHIP_1 = preload("res://scenes/ship_1.tscn")

@onready var ship_1: CharacterBody3D = $ship_1
@onready var debug: Label = $Debug
@onready var hud:HUD = $Hud
@onready var camera: Camera3D = $Camera3D
@onready var loading_label: Label = $LoadingLabel
@onready var pause_box: VBoxContainer = $PauseBox
@onready var world_environment: WorldEnvironment = $WorldEnvironment

var fire_cadence = 0.2
var fire_cooldown = 0.0
var current_level
var level_loaded = false
var level_loading = false
var thread
var global_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_box.visible = false
	GameManager.set_boundary(
		$"Boundary/LeftWall".position.x,
		$"Boundary/RightWall".position.x,
		$"Boundary/TopWall".position.z,
		$"Boundary/BottomWall".position.z
	)
	GameManager.set_camera(camera)
	GameManager.set_world_environment(world_environment)
	GameManager.spawn_stars(self)
	ship_1.connect("player_destroyed", Callable(self, "_on_player_destroyed"))
	ship_1.connect("update_hud", Callable(self, "_on_update_hud"))
	ship_1.init()
	GameManager.set_player(ship_1)
	hud.hide_boss_section()
	debug.init(ship_1)

func _input(_event):
	if Input.is_action_just_pressed("main_menu"):
		GameManager.release_mouse()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
	if Input.is_action_just_pressed("pause_game"):
		pause_game()

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		pause_game()

func pause_game():
	pause_box.visible = true
	GameManager.set_pause_environment()
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level_loaded:
		pause_box.visible = get_tree().paused
		global_time += delta
		RenderingServer.global_shader_parameter_set("global_time", global_time)
		GameManager.process_background(self, delta)
		GameManager.process_debris(delta)
		current_level.process(self, delta)
		if Input.is_action_pressed("shoot_primary") and fire_cooldown <= 0:
			fire_bullet()
		fire_cooldown -= delta
	elif not level_loading:
		thread = Thread.new()
		thread.start(Callable(self, "load_level").bind("tutorial"))

func load_level(level_name):
	Thread.set_thread_safety_checks_enabled(false)
	level_loading = true
	current_level = LevelManager.load_level(level_name)
	current_level.init(self, [SHIP_1])
	level_loaded = true
	level_loading = false
	thread.call_deferred("wait_to_finish")
	loading_label.visible = false

func fire_bullet():
	if Utils.is_valid_node(ship_1):
		fire_cooldown = fire_cadence
		GameManager.fire_player_weapon(self)

func _on_player_destroyed():
	GameManager.create_explosion(self, ship_1, 30, 30)

func _on_enemy_destroyed(enemy):
	GameManager.create_explosion(self, enemy, 15, 15)

func _on_show_hit_effect(enemy, bullet):
	GameManager.create_hit_effect(self, enemy, bullet)

func _on_update_hud():
	hud.set_player_values(ship_1)

func _on_weapon_fired(enemy, event):
	GameManager.fire_enemy_weapon(self, enemy, event)

func _exit_tree() -> void:
	if thread.is_alive():
		thread.wait_to_finish()
