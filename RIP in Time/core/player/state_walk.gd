extends State

class_name WalkState

var move_speed = Vector2(90, 0)
var min_move_speed = 0.005


func _ready():
	pstate.velocity += move_speed
	get_node("../PlayerInput").connect("input_intent", self, "_handle_intent")
	
func _exit_tree():
	get_node("../PlayerInput").disconnect("input_intent", self, "_handle_intent")
	
func _handle_intent(action):
	if action == PlayerInput.Action.NONE:
		change_state("idle")
	elif action == PlayerInput.Action.MOVE_FORWARD:
		move_right()
	elif action == PlayerInput.Action.MOVE_BACK:
		move_left()

func _physics_process(_delta):
	if abs(pstate.velocity.length()) < min_move_speed:
		 change_state("idle")

func move_left():
	animated_sprite.play("walk_l")
	if not is_direction_right():
		pstate.velocity.x = max(pstate.velocity.x, move_speed.x)
	else:
		change_state("idle")

func move_right():
	animated_sprite.play("walk_r")
	if is_direction_right():
		pstate.velocity.x = max(pstate.velocity.x, move_speed.x)
	else:
		change_state("idle")
