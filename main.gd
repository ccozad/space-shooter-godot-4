extends Node3D

@onready var ship_1: CharacterBody3D = $ship_1
@onready var debug: Label = $Debug

var fire_cadence = 0.2
var fire_cooldown = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.set_boundary(
		$"Boundary/LeftWall".position.x,
		$"Boundary/RightWall".position.x,
		$"Boundary/TopWall".position.z,
		$"Boundary/BottomWall".position.z
	)
	GameManager.spawn_stars(self)
	GameManager.spawn_asteroids(self)
	ship_1.connect("player_destroyed", Callable(self, "_on_player_destroyed"))
	ship_1.init()
	GameManager.set_player(ship_1)
	debug.init(ship_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameManager.process_background(self, delta)
	if Input.is_action_pressed("shoot_primary") and fire_cooldown <= 0:
		fire_bullet()
	fire_cooldown -= delta

func fire_bullet():
	if Utils.is_valid_node(ship_1):
		fire_cooldown = fire_cadence
		GameManager.fire_player_weapon(self)

func _on_player_destroyed():
	ship_1.queue_free()

func _on_enemy_destroyed(enemy):
	enemy.queue_free()
