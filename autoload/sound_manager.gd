extends Node

@onready var bullet_sound: AudioStreamPlayer = $BulletSound
@onready var explosion_sound: AudioStreamPlayer = $ExplosionSound
@onready var rock_hit_sound = [$RockHit, $RockHit2, $RockHit3]
@onready var metal_hit_sound: AudioStreamPlayer = $MetalHit
@onready var enemy_bullet_sound: AudioStreamPlayer = $EnemyBulletSound

var master_bus
var music_bus
var sound_effects_bus

func _ready():
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sound_effects_bus = AudioServer.get_bus_index("SoundEffects")

func set_master_volume(value):
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))

func set_music_volume(value):
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

func set_sound_effects_volume(value):
	AudioServer.set_bus_volume_db(sound_effects_bus, linear_to_db(value))

func fire_bullet():
	bullet_sound.play()

func fire_enemy_bullet():
	enemy_bullet_sound.play()

func explode():
	explosion_sound.play()

func rock_hit():
	var sound = rock_hit_sound.pick_random()
	sound.pitch_scale = randf_range(0.8, 1.2)
	sound.play()

func metal_hit():
	metal_hit_sound.play()
