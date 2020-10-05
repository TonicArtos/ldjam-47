extends Label

onready var source = get_parent().get_parent().get_parent().get_parent()

export(String) var person_name

func _ready():
	var text = person_name +"\n\n"
	if source.occupants_waking.has(person_name):
		text += Story.text.get(person_name + " bad end", "")
	else:
		text += Story.text.get(person_name + " good end", "")
	print(text)
