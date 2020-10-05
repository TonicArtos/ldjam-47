extends KinematicBody2D

class_name MonsterState

var state: State
var target
var velocity = 0
var direction = Vector2()

var states = {
	"attack": MonsterAttack,
	"walk": MonsterWalk,
	"digesting": MonsterDigesting,
}

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("Unknown monster state ", state_name, ".")

onready var parent = get_parent()

func _ready():
	set_physics_process(true)
	change_state("walk")

func _enter_tree():
	$AttackArea.connect("area_entered", self, "_area_entered")
	get_parent().connect("kill_monster", self, "_on_kill_monster")

func _exit_tree():
	$AttackArea.disconnect("area_entered", self, "_area_entered")
	get_parent().disconnect("kill_monster", self, "_on_kill_monster")

func change_state(new_state_name):
	if is_instance_valid(state):
		state.disconnect("interact", self, "_do_attack")
		state.queue_free()
	state = get_state(new_state_name).new()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	state.connect("interact", self, "_do_interaction")
	add_child(state)

func _area_entered(area: Area2D):
	if area.has_method("is_doodad"):
		if area.has_method("is_waking") and area.is_waking():
			target = area.get_target()
			change_state("attack")
	if area.get_parent() == parent.player:
		target = parent.player
		change_state("attack")
