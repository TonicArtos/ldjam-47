extends Node

class_name Dialogue

signal drop_item(item)
signal pickup_item(item)
signal dialogue_complete()

func load_data(target, player):
	var target_data = target.get_dialogue_data(player)
	
	pass
