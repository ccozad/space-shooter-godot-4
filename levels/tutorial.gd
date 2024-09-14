extends Node

var ASTEROID = preload("res://scenes/asteroid.tscn")
var ENEMY_BULLET = preload("res://scenes/enemy_bullet.tscn")
var ENEMY_SHIP_1 = preload("res://scenes/enemy_ship_1.tscn")

var timeline = []
var elapsed_time = 0.0
var previous_second = 0

func init(node):
	timeline.append({"timestamp": 1, "wave": get_asteroid_wave()})
	timeline.append({"timestamp": 3, "wave": get_enemy_ship_wave()})
	timeline.append({"timestamp": 7, "wave": get_asteroid_wave()})
	timeline.append({"timestamp": 12, "wave": get_enemy_ship_wave()})
	print("tutorial scene initialized")

func process(node, delta):
	elapsed_time += delta
	if elapsed_time - previous_second > 1.0:
		previous_second += 1
		for event in timeline:
			if event.timestamp <= elapsed_time and not event.has("processed"):
				process_wave(node, event.wave)
				event.processed = true

func process_wave(node, wave):
	print("Process wave called")
	for item in wave:
		var enemy = item.enemy.instantiate()
		enemy.init(node, item.spawn, item.timeline)
		node.add_child(enemy)

func get_asteroid_wave():
	var wave = []
	for i in 11:
		wave.append({
			"enemy": ASTEROID,
			"spawn": {
				"hit_points": 20,
				"coords": Vector3(Utils.get_random_x_in_viewport(10), 0, GameManager.boundary.top - i * 2),
				"scale": Utils.get_random_vector3_in_range(1, 4),
				"direction": Vector3(0, 0, randf_range(5, 15)),
				"rotation": Utils.get_random_vector3_in_range(0.1, 1)
			},
			"timeline": []
		})
	return wave

func get_enemy_ship_wave():
		var wave = []
		for i in 5:
			wave.append({
				"enemy": ENEMY_SHIP_1,
				"spawn": {
					"hit_points": 20,
					"coords": Vector3(-50 + i * 30, 0, GameManager.boundary.top + 1),
					"scale": Vector3(2, 2, 2),
					"direction": Vector3(0, 0, 2.0),
					"rotation": Vector3(0, 0, 0)
				},
				"timeline": get_enemy_ship_timeline()
			})
		return wave

func get_enemy_ship_timeline():
	return [
		{
			"timestamp": 5,
			"fire": {
				"shot": ENEMY_BULLET,
				"weapon": "Main"
			}
		},
		{
			"timestamp": 10,
			"fire": {
				"shot": ENEMY_BULLET,
				"weapon": "Main"
			}
		}
	]
