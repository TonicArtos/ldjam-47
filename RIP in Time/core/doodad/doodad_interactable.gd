extends Area2D

class_name DoodadInteractable

func parent():
	return get_parent()

func is_doodad():
	pass

func get_dialogue(id: int, item):
	return parent().get_dialogue(id, item)
