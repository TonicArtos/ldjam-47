extends AnimatedSprite

onready var parent = get_parent()

func do_open():
	play("opening" if parent.sprite_suffix.empty() else "opening"+parent.sprite_suffix)
	connect("animation_finished", self, "_on_finished_opening")
	
func do_close():
	play("opening" if parent.sprite_suffix.empty() else "opening"+parent.sprite_suffix, true)
	connect("animation_finished", self, "_on_finished_closing")

func _on_finished_opening():
	set_animation("open" if parent.sprite_suffix.empty() else "open"+parent.sprite_suffix)
	disconnect("animation_finished", self, "_on_finished_opening")
	
func _on_finished_closing():
	set_animation("closed" if parent.sprite_suffix.empty() else "closed"+parent.sprite_suffix)
	disconnect("animation_finished", self, "_on_finished_closing")
