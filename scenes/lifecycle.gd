class_name Lifecycle
extends Node

signal enemy_destroyed(source_node)
signal bullet_hit(enemy, bullet)
signal weapon_fired(enemy, event)

var spawn = {}
var elapsed_time = 0.0
var current_direction
var current_rotation
var speed
var max_hit_points = 0.0
var hit_points = 0.0
var timeline = []
var previous_second = 0.0
var target

func init(root_node, enemy, _spawn, _timeline):
	spawn = _spawn
	timeline = _timeline
	enemy.translate(spawn.coords)
	enemy.scale_object_local(spawn.scale)
	current_direction = spawn.direction
	speed = current_direction.length()
	current_rotation = spawn.rotation
	hit_points = spawn.hit_points
	max_hit_points = hit_points
	if spawn.has("powerup"):
		enemy.powerup = spawn.powerup
	if spawn.has("target"):
		target = spawn.target
	connect("enemy_destroyed", Callable(root_node, "_on_enemy_destroyed"))
	connect("bullet_hit", Callable(root_node, "_on_show_hit_effect"))
	connect("weapon_fired", Callable(root_node, "_on_weapon_fired"))

func process(enemy, delta):
	elapsed_time += delta
	if elapsed_time - previous_second > 1.0:
		previous_second+= 1
		for event in timeline:
			if event.timestamp <= elapsed_time and not event.has("processed"):
				process_event(enemy, event)
				event.processed = true
	if Utils.is_valid_node(target):
		var to_target = target.global_position - enemy.global_position
		current_direction = to_target.normalized() * speed
		var direction_angle = Vector2(to_target.x, to_target.z).angle_to(Vector2.UP)
		enemy.rotation.y = direction_angle
		enemy.global_position = enemy.global_position.move_toward(target.global_position, delta * speed)
	else:
		enemy.global_position.x += current_direction.x * delta
		enemy.global_position.z += current_direction.z * delta
	
	if current_rotation != Vector3.ZERO:
		enemy.rotate_x(current_rotation.x * delta)
		enemy.rotate_y(current_rotation.y * delta)
		enemy.rotate_z(current_rotation.z * delta)

	if elapsed_time > 20 and not GameManager.is_in_boundary(enemy):
		enemy.queue_free()

func process_event(enemy, event):
	if event.has("fire"):
		if event.fire.has("weapon") and GameManager.is_in_boundary(enemy):
			weapon_fired.emit(enemy, event)

func process_hit(enemy, area):
	hit_points -= area.hit_points
	bullet_hit.emit(enemy, area)
	if hit_points <= 0:
		explode(enemy)

func explode(enemy):
	enemy_destroyed.emit(enemy)
