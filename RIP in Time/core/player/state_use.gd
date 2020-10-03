extends State

class_name UseState


func _ready():
	animated_sprite.play("use")
	pstate.velocity.x = 0
	get_parent().connect("use_complete", self, "_use_complete")

func _use_complete():
	change_state("idle")

func _process(_delta):
	pass

func _physics_process(_delta):
	pstate.velocity.x = 0
