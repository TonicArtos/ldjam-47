extends KinematicBody2D

class_name PlayerState

var state: State
var state_factory: PlayerStates

var velocity = Vector2()
var direction = State.RIGHT
var _doodads_overlapping := []
var _items_overlapping := []
var carried_item = null

signal interact_with(target)
signal drop_item(item)

func _ready():
	set_physics_process(true)
	state_factory = PlayerStates.new()
	change_state("idle")
	$InteractArea.connect("area_entered", self, "_area_entered")
	$InteractArea.connect("area_exited", self, "_area_exited")
	get_parent().connect("interact_complete", self, "_on_interaction_complete")
	get_parent().connect("pickup_item", self, "_on_pickup_item")
	
	
func _exit_tree():
	$InteractArea.disconnect("area_entered", self, "_area_entered")
	$InteractArea.disconnect("area_exited", self, "_area_exited")
	get_parent().disconnect("interact_complete", self, "_on_interaction_complete")
	get_parent().disconnect("pickup_item", self, "_on_pickup_item")

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
	if area.has_method("is_doodad"):
		_doodads_overlapping.append(area)
	elif area.has_method("is_item"):
		_items_overlapping.append(area)
	
func _area_exited(area):
	if area.has_method("is_doodad"):
		_doodads_overlapping.erase(area)
	elif area.has_method("is_item"):
		_items_overlapping.erase(area)

func _do_interaction():
	var target
	if _items_overlapping.size() > 0:
		target = _items_overlapping.front()
	elif _doodads_overlapping.size() > 0:
		target = _doodads_overlapping.front()
	else:
		target = get_parent()
	emit_signal("interact_with", target)
	change_state("use")

func _on_interaction_complete():
	change_state("idle")

func _on_pickup_item(item):
	carried_item = item

func _on_drop_item():
	emit_signal("drop_item", carried_item)
	carried_item = null

func _on_die():
	pass
