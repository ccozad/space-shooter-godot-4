extends Node3D

@onready var ship_1: CharacterBody3D = $ship_1
@onready var debug: Label = $Debug


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug.init(ship_1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
