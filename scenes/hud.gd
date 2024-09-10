extends CanvasLayer

@onready var player_hull_integrity_power_bar: ProgressBar = $Player/GridContainer/PlayerHullIntegrityPowerBar
@onready var player_shield_power_bar: ProgressBar = $Player/GridContainer/PlayerShieldPowerBar

func set_player_values(player):
	tween_property(player_hull_integrity_power_bar, "value", player.hull_integrity)
	tween_property(player_shield_power_bar, "value", player.shield_power)
	
	
func tween_property(element, property, value):
	if value != element.get(property):
		var tween = get_tree().create_tween()
		tween.tween_property(element, "value", value, 1)	
