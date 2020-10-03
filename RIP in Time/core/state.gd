extends Node2D

class_name State

var change_state_callback
var animated_sprite
var persistent_state

func change_state(dest_state):
	change_state_callback.call_func(dest_state)

func _physics_process(_delta):
	persistent_state.move_and_slide(persistent_state.velocity, Vector2.UP)
 
func setup(change_state, animated_sprite, persistent_state):
	self.change_state_callback = change_state
	self.animated_sprite = animated_sprite
	self.persistent_state = persistent_state

func move_left():
	pass

func move_right():
	pass

