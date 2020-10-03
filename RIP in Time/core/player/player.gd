extends KinematicBody2D

class_name PersistentState

var state: State
var state_factory: PlayerStates

var velocity = Vector2()

func _ready():
	set_physics_process(true)
	state_factory = PlayerStates.new()
	change_state("idle")

func change_state(new_state_name):
	if is_instance_valid(state):
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)
