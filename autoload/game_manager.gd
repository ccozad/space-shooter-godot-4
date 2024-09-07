extends Node

@onready var SMALL_STAR = preload("res://scenes/small_star.tscn")
@onready var ASTEROID = preload("res://scenes/asteroid.tscn")
@onready var BULLET = preload("res://scenes/bullet.tscn")

var boundary = {
	"left": 0.0,
	"right": 0.0,
	"top": 0.0,
	"bottom": 0.0
}

var boundary_margin = 10.0
var player

func set_player(_player):
	player = _player

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

func spawn_asteroids(root_node):
	for i in 5:
		var spawn = {
			"hit_points": 20,
			"coords": Vector3(-40 + i *20, 0, -40),
			"scale": Utils.get_random_vector3_in_range(1, 4),
			"direction": Vector3(0, 0, randf_range(5, 15)),
			"rotation": Utils.get_random_vector3_in_range(0.1, 1)
		}
		var asteroid = ASTEROID.instantiate()
		asteroid.init(root_node, spawn)
		root_node.add_child(asteroid)

func fire_player_weapon(root_node):
	for weapon in player.weapons:
		if weapon.active:
			var bullet = BULLET.instantiate()
			bullet.init(weapon)
			root_node.add_child(bullet)
	SoundManager.fire_bullet()
