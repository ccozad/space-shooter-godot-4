extends Node

@onready var bullet_sound: AudioStreamPlayer = $BulletSound
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound
@onready var rock_hit_sound = [$RockHit, $RockHit2, $RockHit3]
@onready var metal_hit_sound: AudioStreamPlayer = $MetalHit

func fire_bullet():
	bullet_sound.play()

func explode():
	explosion_sound.play()

func rock_hit():
	var sound = rock_hit_sound.pick_random()
	sound.pitch_scale = randf_range(0.8, 1.2)
	sound.play()

func metal_hit():
	metal_hit_sound.play()
