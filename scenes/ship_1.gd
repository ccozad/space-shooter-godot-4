extends CharacterBody3D

@onready var weapons_node: Node3D = $Weapons

var weapons = []
var tilt = 0.0
var tilt_direction = 0.0
var shift_pressed = false

const SPEED = 30.0
const FAST_SPEED = 80
const MAX_TILT = 0.5
signal player_destroyed()

func init():
	for weapon in weapons_node.get_children():
		if weapon.name == "Main":
			weapon.active = true
		weapons.append(weapon)

func _input(event):
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


func _on_area_3d_area_entered(area: Area3D) -> void:
	player_destroyed.emit()
