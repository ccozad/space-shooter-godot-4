extends Node

var ASTEROID = preload("res://scenes/asteroid.tscn")
var ENEMY_BULLET = preload("res://scenes/enemy_bullet.tscn")
var ENEMY_SHIP_1 = preload("res://scenes/enemy_ship_1.tscn")
var ROCKET = preload("res://scenes/rocket.tscn")
var SHIELD_POWERUP = preload("res://scenes/shield_powerup.tscn")
var WEAPON_POWERUP = preload("res://scenes/weapon_powerup.tscn")
var BULLET = preload("res://scenes/bullet.tscn")
var EXPLOSION = preload("res://scenes/explosion.tscn")
var HIT_EFFECT = preload("res://scenes/hit_effect.tscn")
var STAGE_COMPLETED = preload("res://scenes/stage_completed.tscn")

var timeline = []
var elapsed_time = 0.0
var previous_second = 0

func init(node, more_scenes = []):
	var scenes = [
		ASTEROID, 
		ENEMY_BULLET, 
		ENEMY_SHIP_1, 
		ROCKET, 
		SHIELD_POWERUP, 
		WEAPON_POWERUP,
		BULLET,
		EXPLOSION,
		HIT_EFFECT,
		STAGE_COMPLETED]
	scenes.append_array(more_scenes)
	LevelManager.compile_shaders(node, scenes)
	timeline.append({"timestamp": 1, "wave": get_asteroid_wave()})
	timeline.append({"timestamp": 3, "wave": get_enemy_ship_wave()})
	timeline.append({"timestamp": 6, "wave": get_rocket_wave()})
	timeline.append({"timestamp": 8, "wave": get_asteroid_wave()})
	timeline.append({"timestamp": 12, "wave": get_enemy_ship_wave()})
	timeline.append({"timestamp": 17, "wave": get_asteroid_wave()})
	timeline.append({"timestamp": 21, "action": get_stage_completed()})
	print("tutorial scene initialized")

func process(node, delta):
	elapsed_time += delta
	if elapsed_time - previous_second > 1.0:
		previous_second += 1
		for event in timeline:
			if event.timestamp <= elapsed_time and not event.has("processed"):
				if event.has("wave"):
					process_wave(node, event.wave)
					event.processed = true
				elif event.has("action"):
					process_action(node, event.action)
					event.processed = true
				else:
					print("Unknown event");
					
func process_action(node, actions):
	print("Process lifecycle called")
	for item in actions:
		var action = item.action.instantiate()
		action.init(item.parameters)
		node.add_child(action)		

func get_stage_completed():
	var actions = []
	actions.append({
		"action":  STAGE_COMPLETED,
		"parameters": {
			"next_scene": "menu"
		}
	})
	return actions

func process_wave(node, wave):
	print("Process wave called")
	for item in wave:
		var enemy = item.enemy.instantiate()
		enemy.init(node, item.spawn, item.timeline)
		node.add_child(enemy)

func get_asteroid_wave():
	var wave = []
	var powerup_index = int(randf_range(0, 10))
	for i in 11:
		wave.append({
			"enemy": ASTEROID,
			"spawn": {
				"hit_points": 20,
				"coords": Vector3(Utils.get_random_x_in_viewport(10), 0, GameManager.boundary.top - i * 2),
				"scale": Utils.get_random_vector3_in_range(1, 4),
				"direction": Vector3(0, 0, randf_range(5, 15)),
				"rotation": Utils.get_random_vector3_in_range(0.1, 1),
				"powerup": SHIELD_POWERUP if i == powerup_index else null
			},
			"timeline": []
		})
	return wave

func get_enemy_ship_wave():
		var wave = []
		var powerup_index = int(randf_range(0, 4))
		for i in 5:
			wave.append({
				"enemy": ENEMY_SHIP_1,
				"spawn": {
					"hit_points": 20,
					"coords": Vector3(-50 + i * 30, 0, GameManager.boundary.top + 1),
					"scale": Vector3(2, 2, 2),
					"direction": Vector3(0, 0, 2.0),
					"rotation": Vector3(0, 0, 0),
					"powerup": WEAPON_POWERUP if i == powerup_index else null
				},
				"timeline": get_enemy_ship_timeline()
			})
		return wave
		
func get_rocket_wave():
	var wave = []
	for i in 2:
		wave.append({
			"enemy": ROCKET,
			"spawn": {
				"hit_points": 10,
				"coords": Vector3(-50 + i * 100, 0, GameManager.boundary.top + 1),
				"scale": Vector3(0.75, 0.75, 0.75),
				"direction": Vector3(0, 0, 20.0),
				"rotation": Vector3(0, 0, 0),
				"target": GameManager.player
			},
			"timeline": []
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
	
