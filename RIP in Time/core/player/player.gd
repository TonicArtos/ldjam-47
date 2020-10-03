extends KinematicBody2D

class_name PlayerState

var state: State
var state_factory: PlayerStates

var velocity = Vector2()
var direction = State.RIGHT
var _doodads_overlapping := []
var _items_overlapping := []

func _ready():
	set_physics_process(true)
	state_factory = PlayerStates.new()
	change_state("idle")
	$InteractArea.connect("area_entered", self, "_area_entered")
	$InteractArea.connect("area_exited", self, "_area_exited")
	
func _exit_tree():
	$InteractArea.disconnect("area_entered", self, "_area_entered")
	$InteractArea.disconnect("area_exited", self, "_area_exited")

func change_state(new_state_name):
	if is_instance_valid(state):
		state.disconnect("interact", self, "_do_interaction")
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	state.connect("interact", self, "_do_interaction")
	add_child(state)

func _area_entered(area: Area2D):
	var parent = area.get_parent()
	if parent.has_method("is_doodad"):
		_doodads_overlapping.append(parent)
	elif parent.has_method("is_item"):
		_items_overlapping.append(parent)
	
func _area_exited(area):
	var parent = area.get_parent()
	if parent.has_method("is_doodad"):
		_doodads_overlapping.erase(parent)
	elif parent.has_method("is_item"):
		_items_overlapping.erase(parent)

func _do_interaction():
	change_state("use")
	
