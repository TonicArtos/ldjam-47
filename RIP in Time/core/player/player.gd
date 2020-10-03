extends KinematicBody2D

class_name PlayerState

var state: State
var state_factory: PlayerStates

var velocity = Vector2()

func _ready():
	state_factory = PlayerStates.new()
	change_state("idle")

func change_state(new_state_name):
	if is_instance_valid(state):
		state.queue_free() # Removes state node after this frame.
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)
