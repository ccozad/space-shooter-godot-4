extends Node

var current_level

func load_level(level):
	print("Loading level: " + level)
	current_level = load("res://levels/" + level + ".gd").new()
	return current_level

func compile_shaders(node, scenes):
	print("Compiling shaders")
	var materials = Utils.get_all_materials_from_scene(scenes)
	for key in materials:
		var new_mesh: MeshInstance3D = MeshInstance3D.new()
		new_mesh.mesh = QuadMesh.new()
		new_mesh.add_to_group("mesh")
		new_mesh.set_surface_override_material(0, materials[key])
		new_mesh.position = Vector3(
			GameManager.boundary.left + GameManager.boundary_margin / 2.0,
			0,
			GameManager.boundary.bottom - GameManager.boundary_margin / 2.0)
		node.call_deferred("add_child", new_mesh)
