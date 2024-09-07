extends Node

@onready var bullet_sound: AudioStreamPlayer = $BulletSound

func fire_bullet():
	bullet_sound.play()
