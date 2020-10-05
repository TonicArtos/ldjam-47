extends State

class_name MonsterAttack

var move_speed = 180

var player

func _enter_tree():
	player = get_parent().get_parent().player

func _ready():
	if pstate.target == player:
		player.kill()
	animated_sprite.play("attack")
	animated_sprite.connect("animation_finished", self, "_on_attack_complete")

func _physics_process(_delta):
	var vector: Vector2 = player.position - pstate.position
	pstate.direction = vector.normalized()
	#pstate.rotate(pstate.position.angle_to_point(player.position) - pstate.rotation)
	pstate.velocity = max(pstate.velocity, move_speed)

func _on_attack_complete():
	change_state("digesting")
