extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "_on_animation_finished")

func _exit_tree():
	disconnect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	self.queue_free()
