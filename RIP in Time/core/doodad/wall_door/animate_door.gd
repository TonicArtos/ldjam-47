
extends AnimatedSprite

func do_open():
	play("opening")
	connect("animation_finished", self, "_on_finished_opening")

func do_close():
	play("opening", true)
	connect("animation_finished", self, "_on_finished_closing")

func _on_finished_opening():
	set_animation("open")
	disconnect("animation_finished", self, "_on_finished_opening")
	
func _on_finished_closing():
	set_animation("closed")
	disconnect("animation_finished", self, "_on_finished_closing")
