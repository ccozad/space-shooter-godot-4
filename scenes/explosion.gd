extends Node3D

@onready var fire: MeshInstance3D = $fire

var fire_width
var fire_height
var fire_speed
var fire_aperature = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire.mesh.size = Vector2(fire_width, fire_height)

func init(x, z, width, height, speed = 1.0):
	translate(Vector3(x, 0, z))
	fire_width = width
	fire_height = height
	fire_speed = speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fire_aperature < 1.0:
		fire_aperature += delta * fire_speed
		fire.set_instance_shader_parameter("fire_aperature", fire_aperature)
	else:
		queue_free()
