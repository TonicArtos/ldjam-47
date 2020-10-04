extends State

class_name IdleState

func _ready():
	if is_direction_right():
		animated_sprite.play("idle_r")
	else:
		animated_sprite.play("idle_l")
	pstate.velocity.x = 0
	get_node("../PlayerInput").connect("input_intent", self, "_handle_intent")

func _exit_tree():
	get_node("../PlayerInput").disconnect("input_intent", self, "_handle_intent")

func _handle_intent(action):
	if action == PlayerInput.Action.MOVE_FORWARD:
		move_right()
	elif action == PlayerInput.Action.MOVE_BACK:
		move_left()
	elif action == PlayerInput.Action.USE:
		perform_use()

func _physics_process(_delta):
	pstate.velocity.x = 0



func _flip_direction():
	if is_direction_right():
		pstate.direction = State.LEFT
		animated_sprite.play("idle_l")
	else:
		pstate.direction = State.RIGHT
		animated_sprite.play("idle_r")

func move_left():
	if not is_direction_right():
		change_state("walk")
	else:
		_flip_direction()
		change_state("walk")

func move_right():
	if is_direction_right():
		change_state("walk")
	else:
		_flip_direction()
		change_state("walk")

func perform_use():
	emit_signal("interact")
