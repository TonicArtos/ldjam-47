extends Sprite

signal item_picked_up(item)

func get_floor_y_position():
	return $Interactable.FLOOR_POSITION

func get_dialogue(id: int, item):
	return $Interactable.get_dialogue(id, item)

func get_look_at_option():
	return $Interactable.get_look_at_option()
