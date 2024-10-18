class_name StageCompleted
extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var next_scene = "menu"

func init(paramters):
	if(paramters.next_scene):
		next_scene = paramters.next_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fade_in")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Stage completed animation completed")
	get_tree().change_scene_to_file("res://scenes/" + next_scene + ".tscn")
