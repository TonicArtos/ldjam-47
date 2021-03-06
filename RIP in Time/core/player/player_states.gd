class_name PlayerStates

var states

func _init():
	states = {
		"idle": IdleState,
		"walk": WalkState,
		"use": UseState,
		"intro": IntroState,
	}

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("Unknown player state ", state_name, ".")
