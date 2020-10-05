tool
extends Node2D

class_name Reactor

func is_doodad():
	pass

export var is_running = false
export var has_key = false

signal contaminant_released()
signal used_key()

var dialogues = {
	0 : Story.Message.new("reactor greeting", []), #dyn options
	1 : Story.Message.new("maintenance denied", [Story.Option.new(0, "back")]),
	2 : Story.Message.new("maintenance approved", [Story.Option.new(3, "retract shielding"), Story.default_done()]),
	3 : Story.Message.new("key inserted", [Story.Option.new(1, "enter maintenance mode"), Story.default_done()]),
	4 : Story.Message.new("monster released", [Story.Option.new(4, "stabilise reaction")]),
	5 : Story.Message.new("stabilise reaction", [Story.default_done()]),
}

func get_dialogue(id: int, item):
	if is_running and id == 0:
		id = 50
	var r
	match id:
		0:
			r = dialogues[0]
			if item != null and item.get_item_type() == "key fob":
				r.options = [
					Story.Option.new(1, "enter maintenance mode"),
					Story.Option.new(2, "insert key"),
					Story.default_done(),
				]
			else:
				r.options =	[
					Story.Option.new(1, "enter maintenance mode"),
					Story.default_done(),
				]
		1:
			if has_key:
				r = dialogues[2]
			else:
				r = dialogues[1]
		2:
			r = dialogues[3]
			emit_signal("used_key")
			has_key = true
		3:
			r = dialogues[4]
			emit_signal("contaminant_released")
		4:
			r = dialogues[5]
	return r
