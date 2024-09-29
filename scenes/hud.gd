class_name HUD
extends CanvasLayer

@onready var boss: MarginContainer = $Boss
@onready var player_hull_integrity_power_bar: ProgressBar = $Player/GridContainer/PlayerHullIntegrityPowerBar
@onready var player_shield_power_bar: ProgressBar = $Player/GridContainer/PlayerShieldPowerBar
@onready var boss_hull_integrity_power_bar: ProgressBar = $Boss/GridContainer/BossHullIntegrityPowerBar
@onready var boss_shield_power_bar: ProgressBar = $Boss/GridContainer/BossShieldPowerBar

func set_player_values(player):
	tween_property(player_hull_integrity_power_bar, "value", player.hull_integrity)
	tween_property(player_shield_power_bar, "value", player.shield_power)

func set_boss_values(_boss):
	tween_property(boss_hull_integrity_power_bar, "value", _boss.get_hull_integrity())
	tween_property(boss_shield_power_bar, "value", _boss.get_shield_power())
	
func tween_property(element, property, value):
	if value != element.get(property):
		var tween = get_tree().create_tween()
		tween.tween_property(element, "value", value, 1)	

func show_boss_section():
	boss.visible = true

func hide_boss_section():
	boss.visible = false;
	
