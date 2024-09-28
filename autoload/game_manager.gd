extends Node

@onready var SMALL_STAR = preload("res://scenes/small_star.tscn")
@onready var ASTEROID = preload("res://scenes/asteroid.tscn")
@onready var BULLET = preload("res://scenes/bullet.tscn")
@onready var EXPLOSION = preload("res://scenes/explosion.tscn")
@onready var HIT_EFFECT = preload("res://scenes/hit_effect.tscn")

var boundary = {
	"left": 0.0,
	"right": 0.0,
	"top": 0.0,
	"bottom": 0.0
}

var boundary_margin = 10.0
var player
var camera
var world_environment
var mouse_captured = false

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func set_player(_player):
	player = _player

func set_camera(_camera):
	camera = _camera

func set_world_environment(_world_environment):
	world_environment = _world_environment

func set_boundary(left, right, top, bottom):
	boundary.left = left
	boundary.right = right
	boundary.top = top
	boundary.bottom = bottom

func is_in_boundary(node, add_margin = true):
	var margin = boundary_margin if add_margin else 0.0
	return (node.global_position.x > boundary.left - margin
		and node.global_position.x < boundary.right + margin
		and node.global_position.z > boundary.top - margin
		and node.global_position.z < boundary.bottom + margin)

func set_pause_environment():
	world_environment.environment.volumetric_fog_enabled = true
	world_environment.environment.volumetric_fog_albedo = Color("#292929")

func clear_pause_environment():
	world_environment.environment.volumetric_fog_enabled = false

func to_2D(vector3):
	return camera.unproject_position(vector3)

func spawn_stars(root_node):
	for i in 40:
		spawn_star(root_node, false)

func spawn_star(root_node, on_top):
	var star = SMALL_STAR.instantiate()
	star.init(
		randf_range(boundary.left, boundary.right),
		randf_range(-20.0, -50),
		boundary.top - boundary_margin if on_top else randf_range(boundary.top, boundary.bottom),
		randf_range(0.02, 0.2)
	)
	root_node.add_child(star)

func process_background(root_node, delta):
	for small_star in get_tree().get_nodes_in_group("small_star"):
		small_star.global_position.z += small_star.vertical_speed * delta
		var z = small_star.position.z
		if z > boundary.bottom + boundary_margin:
			small_star.queue_free()
			spawn_star(root_node, true)

func process_debris(delta):
	for mesh in get_tree().get_nodes_in_group("debris"):
		mesh.global_translate(mesh.get_meta("vector") * delta * 10)
		mesh.rotate(Vector3(1,0,0), mesh.get_meta("rotation").x * delta)
		mesh.rotate(Vector3(0,1,0), mesh.get_meta("rotation").y * delta)
		mesh.rotate(Vector3(0,0,1), mesh.get_meta("rotation").z * delta)
		var time_left = mesh.get_meta("timer") - delta
		if time_left <= 0 or not is_in_boundary(mesh):
			mesh.queue_free()
		else:
			mesh.set_meta("timer", time_left)

func fire_player_weapon(root_node):
	for weapon in player.weapons:
		if weapon.active:
			var bullet = BULLET.instantiate()
			bullet.init(weapon)
			root_node.add_child(bullet)
			SoundManager.fire_bullet()

func create_explosion(root_node, source_node, width, height):
	var explosion = EXPLOSION.instantiate()
	var speed = 1.0
	explosion.init(source_node.global_transform.origin.x,
		source_node.global_transform.origin.z,
		width,
		height,
		speed)
	root_node.add_child(explosion)
	SoundManager.explode()
	if source_node is Enemy:
		spawn_powerup(root_node, source_node)
	if source_node.is_in_group("modules"):
		for module in Utils.get_all_children(source_node):
			if module is MeshInstance3D:
				create_debris_from_module(root_node, module, source_node.scale)
	source_node.queue_free()

func create_debris_from_module(root_node, module, scale):
	var debris = module.duplicate()
	debris.add_to_group("debris")
	debris.set_layer_mask_value(1, false)
	debris.set_layer_mask_value(10, true)
	debris.set_meta("vector", Vector3(randf_range(-1, 1.0), randf_range(-1, 1.0), randf_range(-1, 1.0)))
	debris.set_meta("rotation", Vector3(randf_range(-1, 1.0), randf_range(-1, 1.0), randf_range(-1, 1.0)))
	debris.set_meta("timer", 10.0)
	debris.scale_object_local(scale)
	debris.position = module.global_transform.origin
	root_node.add_child(debris)

func create_hit_effect(root_node, enemy, bullet):
	var hit_effect = HIT_EFFECT.instantiate()
	hit_effect.init(bullet.position.x, bullet.position.z)
	root_node.add_child(hit_effect)
	if enemy.is_in_group("metal"):
		SoundManager.metal_hit()
	else:
		SoundManager.rock_hit()

func fire_enemy_weapon(root_node, enemy, event):
	for weapon in enemy.weapons:
		if weapon.name == event.fire.weapon:
			if is_in_boundary(weapon, false):
				var bullet = event.fire.shot.instantiate()
				bullet.init(weapon, enemy.rotation.y)
				root_node.add_child(bullet)
				SoundManager.fire_enemy_bullet()

func spawn_powerup(root_node, enemy):
	var powerup_scene = enemy.powerup
	if powerup_scene != null:
		var powerup = powerup_scene.instantiate()
		powerup.init(enemy)
		root_node.add_child(powerup)
		
