extends HBoxContainer

class_name MenuEntry

signal entry_picked(entry_id)

var entry_id: int

func load_data(entry_text: String, id):
	entry_id = id
	$Label.text = entry_text
	print($Label.text)

func is_selected(selected: bool):
	$Selector.text = '>' if selected else ''
