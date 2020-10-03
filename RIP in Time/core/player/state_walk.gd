extends State

class_name WalkState

var move_speed = Vector2(10, 0)
var min_move_speed = 0.005


func _ready():
	animated_sprite.play("walk")
	if animated_sprite.flip_h:
		move_speed.x *= -1
	persistent_state.velocity += move_speed

func _process(_delta):
	if Input.is_action_just_released("ui_left"):
		change_state("idle")
	elif Input.is_action_just_released("ui_right"):
		change_state("idle")
	elif Input.is_action_pressed("ui_left"):
		move_left()
	elif Input.is_action_pressed("ui_right"):
		move_right()

func _physics_process(_delta):
	if abs(persistent_state.velocity.length()) < min_move_speed:
		 change_state("idle")

func move_left():
	if animated_sprite.flip_h:
		persistent_state.velocity.x = max(persistent_state.velocity.x, move_speed.x)
	else:
		change_state("idle")

func move_right():
	if not animated_sprite.flip_h:
		persistent_state.velocity.x = max(persistent_state.velocity.x, move_speed.x)
	else:
		change_state("idle")
