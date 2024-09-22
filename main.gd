extends Node3D

@onready var ship_1: CharacterBody3D = $ship_1
@onready var debug: Label = $Debug
@onready var hud:HUD = $Hud
@onready var camera: Camera3D = $Camera3D


var fire_cadence = 0.2
var fire_cooldown = 0.0
var current_level
var level_loaded = false

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
	ship_1.connect("player_destroyed", Callable(self, "_on_player_destroyed"))
	ship_1.connect("update_hud", Callable(self, "_on_update_hud"))
	ship_1.init()
	GameManager.set_player(ship_1)
	hud.hide_boss_section()
	debug.init(ship_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if level_loaded:
		GameManager.process_background(self, delta)
		GameManager.process_debris(delta)
		current_level.process(self, delta)
		if Input.is_action_pressed("shoot_primary") and fire_cooldown <= 0:
			fire_bullet()
		fire_cooldown -= delta
	else:
		current_level = LevelManager.load_level("tutorial")
		current_level.init(self)
		level_loaded = true

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
