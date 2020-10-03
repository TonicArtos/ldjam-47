extends State

class_name IdleState

func _ready():
	animated_sprite.play("idle")
	pstate.velocity.x = 0
	get_node("../PlayerInput").connect("input_intent", self, "_handle_intent")

func _exit_tree():
	get_node("../PlayerInput").disconnect("input_intent", self, "_handle_intent")

func _handle_intent(action):
	if action == PlayerInput.Action.MOVE_FORWARD:
		move_right()
	elif action == PlayerInput.Action.MOVE_BACK:
		print("back")
		move_left()

func _physics_process(_delta):
	pstate.velocity.x = 0

func _flip_direction():
	animated_sprite.flip_h = not animated_sprite.flip_h
	if animated_sprite.flip_h:
		pstate.direction = State.LEFT
	else:
		pstate.direction = State.RIGHT

func move_left():
	if animated_sprite.flip_h:
		change_state("walk")
	else:
		_flip_direction()
		change_state("walk")

func move_right():
	if not animated_sprite.flip_h:
		change_state("walk")
	else:
		_flip_direction()
		change_state("walk")


