extends Area3D

@onready var trail: Line2D = $Trail

var current_direction
@export var hit_points = 10.0
@export var speed = 150.0

func init(weapon):
	position = weapon.global_position
	position.y = 0
	var direction_node = weapon.get_children()[0]
	current_direction = direction_node.position
	var direction_angle = Vector2(current_direction.x, current_direction.z).angle_to(Vector2.UP)
	rotate_y(direction_angle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector3(0, 0, -delta * speed))
	trail.add_new_point(GameManager.to_2D(global_position))
	if not GameManager.is_in_boundary(self):
		queue_free()
