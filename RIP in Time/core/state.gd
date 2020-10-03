extends Node2D

class_name State

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

var change_state_callback
var animated_sprite
var pstate : KinematicBody2D

func change_state(dest_state):
	change_state_callback.call_func(dest_state)

func _physics_process(delta):
	var r := pstate.move_and_collide(pstate.direction.normalized() * pstate.velocity * delta)
	if r != null:
		print(r.travel, r.remainder)
	#pstate.move_and_slide(pstate.velocity, Vector2.UP)
 
func setup(change_state, animated_sprite, pstate):
	self.change_state_callback = change_state
	self.animated_sprite = animated_sprite
	self.pstate = pstate

func move_left():
	pass

func move_right():
	pass

