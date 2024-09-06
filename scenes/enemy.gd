class_name Enemy
extends Area3D

var lifecycle = Lifecycle.new()

func init(root_node, spawn):
	lifecycle.init(root_node, self, spawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifecycle.process(self, delta)


func _on_area_entered(area: Area3D) -> void:
	print(area)
