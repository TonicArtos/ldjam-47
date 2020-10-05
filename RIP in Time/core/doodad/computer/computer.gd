tool
extends Node2D

export(bool) var has_key: bool
export(bool) var is_self_destruct: bool

class_name Computer

func is_doodad():
	pass

signal picked_up_key()
signal self_destruct()
	
var dialogues = {
	0 : Story.Message.new("main computer message", [Story.Option.new(1, "login"), Story.default_done()]),
	1 : Story.Message.new("main computer login success", [
			Story.Option.new(10, "view ship log"),
			Story.Option.new(20, "initiate self-destruct"),
			Story.Option.new(30, "access security fob"),
			Story.Option.new(100, "logout"),
		]),
	10 : Story.Message.new("view log", [Story.Option.new(1, "back")]),
	20 : Story.Message.new("self destruct 1", [Story.Option.new(1, "cancel"), Story.Option.new(21, "confirm")]),
	21 : Story.Message.new("self destruct 2", [Story.default_done()]),
	30 : Story.Message.new("take key 1", [Story.Option.new(1, "back")]),
	31 : Story.Message.new("take key 2", [Story.Option.new(1, "back")]),
}

func get_dialogue(id: int, item):
	if is_self_destruct:
		return dialogues[21]
	var r
	match id:
		0:
			r = dialogues[0]
		1:
			r = dialogues[1]
		10: 
			r = dialogues[10]
		20:
			r = dialogues[20]
		21: 
			r = dialogues[21]
			emit_signal("self_destruct")
			is_self_destruct = true
		30:
			if has_key:
				r = dialogues[30]
				emit_signal("picked_up_key")
				has_key = false
			else:
				r = dialogues[31]
	return r


