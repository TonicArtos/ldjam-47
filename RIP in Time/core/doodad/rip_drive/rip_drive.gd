extends Node2D

const _KeyFobItem = preload("res://core/item/key_fob/key_fob.gd")

class_name RipDrive

func is_doodad():
	pass

signal rip_operated() # starts explosion count down, 5 seconds
signal key_thrown_in_rip() # sends key back to beginning of loop

var dialogues = {
	0 : Story.Message.new(
		"rip drive", 
		[
			Story.Option.new(1, "confirm"),
			Story.default_done(),
		]
	),
	1 : Story.Message.new("operate rip drive", [Story.default_done()]),
	2 : Story.Message.new("throw key", [Story.default_done()]),
}

func get_dialogue(id: int, item):
	var r
	match id:
		0:
			r = dialogues[0]
		1:
			r = dialogues[1]
			#if item is KeyFobItem:
			r.options.push_front(Story.Option.new(2, "throw key"))
			emit_signal("rip_operated")
		2:
			r = dialogues[2]
			emit_signal("key_thrown_in_rip")
	return r

