extends State

class_name MonsterWalk

var move_speed = 20

var player

func _ready():
	animated_sprite.play("walk")

func _enter_tree():
	player = get_parent().get_parent().player

func _exit_tree():
	player = null

func _physics_process(_delta):
	var vector: Vector2 = player.position - pstate.position
	pstate.direction = vector.normalized()
	#pstate.rotate(pstate.position.angle_to_point(player.position) - pstate.rotation)
	pstate.velocity = max(pstate.velocity, move_speed)
