extends State

class_name UseState

func _ready():
	animated_sprite.play("use")

func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		move_left()
	elif Input.is_action_just_pressed("ui_right"):
		move_right()

func _physics_process(_delta):
	pstate.velocity.x = 0

func _flip_direction():
	animated_sprite.flip_h = not animated_sprite.flip_h

func move_left():
	if animated_sprite.flip_h:
		change_state("walk")
	else:
		_flip_direction()

func move_right():
	if not animated_sprite.flip_h:
		change_state("walk")
	else:
		_flip_direction()
