extends VBoxContainer

class_name DialogueMenu

var current_selection: int = 0

signal menu_entry_chosen(id)

func add_entry(menu_entry: MenuEntry):
	add_child(menu_entry)
	menu_entry.is_selected(get_child_count() - 1 == current_selection)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var id = get_child(current_selection).entry_id
		emit_signal("menu_entry_chosen", id)
		self.queue_free()
	elif Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down"):
		if current_selection < get_child_count() - 1:
			get_child(current_selection).is_selected(false)
			current_selection += 1
			get_child(current_selection).is_selected(true)
	elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up"):
		if current_selection > 0:
			get_child(current_selection).is_selected(false)
			current_selection -= 1
			get_child(current_selection).is_selected(true)
