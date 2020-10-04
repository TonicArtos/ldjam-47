extends AnimatedSprite

var only_once := true

func _ready():
	connect("animation_finished", self, "_on_animation_finished")

func _exit_tree():
	disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	if only_once:
		self.queue_free()
