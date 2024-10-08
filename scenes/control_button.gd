extends Button

@export var action = "move_up"
@export var primary = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_current_key()

func display_current_key():
	var action_events = InputMap.action_get_events(action)
	var current_key = ""
	if primary and action_events.size() > 0:
		current_key = action_events[0].as_text()
	elif not primary and action_events.size() > 1:
		current_key = action_events[1].as_text()
	text = current_key

func _on_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
