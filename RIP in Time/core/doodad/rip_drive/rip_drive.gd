extends Node2D

class_name RipDrive

func is_doodad():
	pass

var is_running = false
var has_battery = true

signal rip_operated() # starts explosion count down, 5 seconds
signal key_thrown_in_rip() # sends key back to beginning of loop
signal picked_up_battery()

var dialogues = {
	0 : Story.Message.new(
		"rip drive", 
		[
			Story.Option.new(4, "inspect"),
			Story.Option.new(1, "confirm"),
			Story.default_done(),
		]
	),
	1 : Story.Message.new("operate rip drive", [Story.default_done()]),
	2 : Story.Message.new("throw key", [Story.default_done()]),
	3 : Story.Message.new("rip drive running", [Story.default_done()]),
	4 : Story.Message.new("inspect rip drive", [
		Story.Option.new(5, "remove battery"),
		Story.Option.new(0, "back"),
	]),
	5 : Story.Message.new("remove battery", [Story.Option.new(0, "back")]),
	6 : Story.Message.new("inspect rip drive battery gone", [Story.Option.new(0, "back")]),
	7 : Story.Message.new("already carrying item", [Story.Option.new(0, "back")]),
}

func get_dialogue(id: int, item):
	if is_running and id == 0:
		id = 3
	var r
	match id:
		0:
			r = dialogues[0]
		1, 3:
			is_running = true
			r = dialogues[id]
			if item != null and item.get_item_type() == "key fob":
				r.options = [Story.Option.new(2, "throw key"), Story.default_done()]
			else:
				r.options = [Story.default_done()]
			emit_signal("rip_operated")
		2:
			r = dialogues[2]
			emit_signal("key_thrown_in_rip")
		4:
			if has_battery:
				r = dialogues[4]
			else:
				r = dialogues[6]
		5:
			if item == null:
				r = dialogues[5]
				emit_signal("picked_up_battery")
				has_battery = false
			else:
				r = dialogues[7]
	return r

