extends CharacterBody3D

@onready var weapons_node: Node3D = $Weapons
@onready var shield: Area3D = $Shield
@onready var shield_collision: CollisionShape3D = $Shield/CollisionShape3D

var weapons = []
var tilt = 0.0
var tilt_direction = 0.0
var shift_pressed = false
var max_hull_integrity = 100.0
var hull_integrity = max_hull_integrity
var max_shield_power = 100.0
var shield_power = max_shield_power

const SPEED = 30.0
const FAST_SPEED = 80.0
const MAX_TILT = 0.5

signal player_destroyed()
signal update_hud()

func init():
	for weapon in weapons_node.get_children():
		if weapon.name == "Main":
			weapon.active = true
		weapons.append(weapon)

func activate_all_weapons():
	for weapon in weapons:
		weapon.active = true

func _input(_event):
	shift_pressed = true if Input.is_action_pressed("accelerate") else false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var speed = FAST_SPEED if shift_pressed else SPEED
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if velocity.x > 0:
		tilt_direction = 1.0
	elif velocity.x < 0:
		tilt_direction = -1.0
	else:
		if tilt > 0:
			tilt_direction = -1.0
		elif tilt < 0:
			tilt_direction = 1.0
		else:
			tilt_direction = 0
	
	var saved_tilt = tilt
	tilt += tilt_direction * delta
	
	if saved_tilt > 0 and tilt < 0 or saved_tilt < 0 and tilt > 0:
		tilt = 0
		tilt_direction = 0
	
	if tilt > -MAX_TILT and tilt < MAX_TILT:
		rotation.z = -tilt
	
	else:
		tilt = clamp(tilt, -MAX_TILT, MAX_TILT)
	move_and_slide()

func activate_shield():
	shield_collision.set_deferred("enabledd", true)
	shield.visible = true

func shield_hit(value):
	shield_power -= value
	
func remove_shield():
	shield_power = 0
	shield_collision.set_deferred("disabled", true)
	shield.visible = false

func process_powerup(powerup):
	if powerup.shield_boost:
		if shield_power == 0:
			activate_shield()
		shield_power = clampf(shield_power + powerup.shield_boost, 0, max_shield_power)
	if powerup.activate_side_weapons:
		activate_all_weapons()
	update_hud.emit()
	powerup.queue_free()
	
func process_hit(area, enemy_impact):
	var value = get_hit_points(area, enemy_impact)
	if shield_power > 0:
		shield_hit(value)
		update_hud.emit()
		if shield_power <= 0:
			value = -shield_power
			remove_shield()
	
	if shield_power <= 0:
		hull_integrity -= value
		update_hud.emit()
		if hull_integrity <= 0:
			player_destroyed.emit()
	
	if enemy_impact:
		if hull_integrity > 0:
			area.explode()
	else:
		area.queue_free()

func get_hit_points(area, enemy_impact):
	return area.lifecycle.hit_points if enemy_impact else area.hit_points

func _on_area_3d_area_entered(area: Area3D) -> void:
	var bullet_impact = area.is_in_group("enemy_bullet")
	var enemy_impact = area.is_in_group("enemy")
	var powerup_impact = area.is_in_group("powerups")
	if bullet_impact or enemy_impact:
		process_hit(area, enemy_impact)
	elif powerup_impact:
		process_powerup(area)

func _on_shield_area_entered(area: Area3D) -> void:
	var bullet_impact = area.is_in_group("enemy_bullet")
	var enemy_impact = area.is_in_group("enemy")
	if bullet_impact or enemy_impact:
		process_hit(area, enemy_impact)
