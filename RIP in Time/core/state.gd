extends Node2D

class_name State

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

var change_state_callback
var animated_sprite: AnimatedSprite
var pstate : KinematicBody2D

signal interact()

func change_state(dest_state):
	change_state_callback.call_func(dest_state)

func _physics_process(delta):
	pstate.move_and_slide(pstate.direction.normalized() * pstate.velocity)
 
func setup(change_state, animated_sprite, pstate):
	self.change_state_callback = change_state
	self.animated_sprite = animated_sprite
	self.pstate = pstate

func move_left():
	pass

func move_right():
	pass

func is_direction_right():
	return pstate.direction.x > 0
