extends Node

var current_level

func load_level(level):
	print("Loading level: " + level)
	current_level = load("res://levels/" + level + ".gd").new()
	return current_level
