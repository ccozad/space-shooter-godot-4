class_name Powerup
extends Area3D

var lifecycle = PowerupLifecycle.new()

@export var shield_boost = 0.0
@export var activate_side_weapons = false

func init(enemy):
	position = enemy.global_position
	lifecycle.init(self)
	enemy.powerup = null

func _process(delta):
	lifecycle.process(self, delta)
