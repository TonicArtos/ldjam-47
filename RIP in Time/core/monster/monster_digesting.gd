extends State

class_name MonsterDigesting

var move_speed = 40

var player

func _ready():
	animated_sprite.play("digesting")

func _enter_tree():
	player = get_parent().get_parent().player

func _exit_tree():
	player = null

func _physics_process(_delta):
	pstate.direction = Vector2()
	pstate.velocity = 0
