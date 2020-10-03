extends Node2D

class_name PlayerInput

signal input_intent(action)

var current_direction = LookDirection.RIGHT

var is_action_just_released_ref := funcref(Input, "is_action_just_released")
var is_action_just_pressed_ref := funcref(Input, "is_action_just_pressed")
var is_action_pressed_ref := funcref(Input, "is_action_pressed")

func _process(delta):
	pass
	
func _physics_process(delta):
	var token = _get_input_bits()
	emit_signal("input_intent", token.action)

func _get_input_bits() -> Token:
	var keys: int = 0
	var looking_right = current_direction == LookDirection.RIGHT
	var token = Token.new(
		_pull_keys(is_action_just_released_ref, looking_right),
		_pull_keys(is_action_just_pressed_ref, looking_right),
		_pull_keys(is_action_pressed_ref, looking_right)
	)
	return token

func _pull_keys(chk_key_cb, looking_right) -> int:
	var keys: int = 0
	if chk_key_cb.call_func("ui_right"):
		keys |= Key.FORWARD if looking_right else Key.BACK
	if chk_key_cb.call_func("ui_left"):
		keys |= Key.BACK if looking_right else Key.FORWARD
	if chk_key_cb.call_func("ui_up"):
		keys |= Key.USE
	return keys

class Token:
	var action

	func _init(up,down,held):
		var actual_keys = down | (~up & held)
		if actual_keys & Key.USE == Key.USE:
			action = Action.USE
		elif actual_keys & DOUBLE_PRESS == DOUBLE_PRESS:
			action = Action.NONE
		elif actual_keys & Key.FORWARD == Key.FORWARD:
			action = Action.MOVE_FORWARD
		elif actual_keys & Key.BACK == Key.BACK:
			action = Action.MOVE_BACK
		else:
			action = Action.NONE
		
		
	func result():
		pass

enum Action {
	NONE = 0,
	MOVE_BACK = 1,
	MOVE_FORWARD = 2,
	USE = 3,
}

enum LookDirection {
	RIGHT,
	LEFT,
}

enum Key {
	FORWARD = 1,
	BACK = 1 << 1,
	USE = 1 << 2,
}

const DOUBLE_PRESS = Key.FORWARD | Key.BACK

enum Event {
	DOWN = 1,
	UP = 1 << 1,
	HOLD = 1 << 2,
}
