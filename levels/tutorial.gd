extends Node

var ASTEROID = preload("res://scenes/asteroid.tscn")

var timeline = []
var elapsed_time = 0.0
var previous_second = 0

func init(node):
	timeline.append({"timestamp": 1, "wave": get_asteroid_wave()})

func process(node, delta):
	elapsed_time += delta
	if elapsed_time - previous_second > 1.0:
		previous_second += 1
		for event in timeline:
			if event.timestamp <= elapsed_time and not event.has("processed"):
				process_wave(node, event.wave)
				event.processed = true

func process_wave(node, wave):
	for item in wave:
		var enemy = item.enemy.instantiate()
		enemy.init(node, item.spawn, item.timeline)
		node.add_child(enemy)

func get_asteroid_wave():
	pass
