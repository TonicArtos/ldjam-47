extends State

class_name WalkState

var move_speed = Vector2(180, 0)
var min_move_speed = 0.005


func _ready():
	animated_sprite.play("walk")
	pstate.velocity += move_speed
	get_node("../PlayerInput").connect("input_intent", self, "_handle_intent")
	
func _exit_tree():
	get_node("../PlayerInput").disconnect("input_intent", self, "_handle_intent")
	
func _handle_intent(action):
	if action == PlayerInput.Action.NONE:
		change_state("idle")
	elif action == PlayerInput.Action.MOVE_FORWARD:
		move_right()
		print("forward")
	elif action == PlayerInput.Action.MOVE_BACK:
		move_left()
		print("back")

func _physics_process(_delta):
	if abs(pstate.velocity.length()) < min_move_speed:
		 change_state("idle")

func move_left():
	if animated_sprite.flip_h:
		pstate.velocity.x = max(pstate.velocity.x, move_speed.x)
	else:
		change_state("idle")

func move_right():
	if not animated_sprite.flip_h:
		pstate.velocity.x = max(pstate.velocity.x, move_speed.x)
	else:
		change_state("idle")
