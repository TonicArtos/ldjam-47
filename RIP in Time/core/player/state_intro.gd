extends State

class_name IntroState

var move_speed = Vector2(10, 0)
var min_move_speed = 0.005

func _ready():
	animated_sprite.play("walk_r")
	pstate.velocity += move_speed

func _physics_process(_delta):
	move_right()
	if abs(pstate.velocity.length()) < min_move_speed:
		 change_state("idle")

func move_right():
	if is_direction_right():
		pstate.velocity.x = max(pstate.velocity.x, move_speed.x)
	else:
		change_state("idle")
