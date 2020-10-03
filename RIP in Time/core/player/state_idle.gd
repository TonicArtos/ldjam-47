extends State

class_name IdleState

func _ready():
	animated_sprite.play("idle")
	persistent_state.velocity.x = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		move_left()
	elif Input.is_action_just_pressed("ui_right"):
		move_right()

func _physics_process(_delta):
	persistent_state.velocity.x = 0

func _flip_direction():
	animated_sprite.flip_h = not animated_sprite.flip_h

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
