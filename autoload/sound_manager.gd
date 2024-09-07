extends Node

@onready var bullet_sound: AudioStreamPlayer = $BulletSound
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound

func fire_bullet():
	bullet_sound.play()

func explode():
	explosion_sound.play()
