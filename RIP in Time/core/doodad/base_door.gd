tool
extends Node2D

export var is_unlocked = false
export var is_axe_door = false
export var is_cabin_door = false
export(String) var destination_room: String
export(String) var from_room: String

signal used_axe()
signal used_battery()
signal entered_door(destination, from_room)

func close_door():
	if $AnimatedSprite.has_method("do_close"):
		$AnimatedSprite.do_close()

func _process(delta):
	if Engine.editor_hint:
		if is_axe_door and is_unlocked:
			$AnimatedSprite.set_animation("propped_open")
		else:
			$AnimatedSprite.set_animation("closed")

func _ready():
	if is_axe_door and is_unlocked:
		$AnimatedSprite.set_animation("propped_open")
	else:
		$AnimatedSprite.set_animation("closed")

var dialogues = {
	0 : Story.Message.new("battery door status", [Story.Option.new(1, "open door"), Story.default_done()]),
	1 : Story.Message.new("battery door status unlocked", [Story.Option.new(1, "open door"), Story.default_done()]),
	2 : Story.Message.new("open door locked", [Story.Option.new(0, "back")]),
	3 : Story.Message.new("open battery door unlocked", [Story.default_done()]),
	4 : Story.Message.new("apply battery to door", [Story.Option.new(0, "back")]),
	10 : Story.Message.new("axe door status", [Story.Option.new(1, "open door"), Story.default_done()]),
	11 : Story.Message.new("axe door status unlocked", [Story.Option.new(1, "open door"), Story.default_done()]),
	12 : Story.Message.new("open door locked", [Story.Option.new(0, "back")]),
	13 : Story.Message.new("open axe door unlocked", [Story.default_done()]),
	14 : Story.Message.new("apply axe to door", [Story.Option.new(0, "back")]),
	20 : Story.Message.new("cabin door status", [Story.Option.new(1, "open door"), Story.default_done()]),
	21 : Story.Message.new("open door locked", [Story.Option.new(0, "back"), Story.default_done()]),
}

func get_dialogue(id: int, item):
	if is_axe_door:
		id += 10
	elif is_cabin_door:
		id += 20
	var r
	match id:
		0:
			id = 1 if is_unlocked else 0
			r = dialogues[id]
			if id == 0 and item != null and item.get_item_type() == "battery":
				r.options = [Story.Option.new(1, "open door"), Story.Option.new(2, "use battery"), Story.default_done()]
			else:
				r.options = [Story.Option.new(1, "open door"), Story.default_done()]
		1:
			id = 3 if is_unlocked else 2
			r = dialogues[id]
			if id == 3:
				$AnimatedSprite.do_open()
				emit_signal("entered_door", destination_room, from_room)
		2:
			r = dialogues[4]
			emit_signal("used_battery")
			is_unlocked = true
		10:
			id = 11 if is_unlocked else 10
			r = dialogues[id]
			if id == 10 and item != null and item.get_item_type() == "axe":
				r.options = [Story.Option.new(11, "open door"), Story.Option.new(2, "use axe"), Story.default_done()]
			else:
				r.options = [Story.Option.new(11, "open door"), Story.default_done()]
		11:
			id = 13 if is_unlocked else 12
			r = dialogues[id]
			if id == 13:
				$AnimatedSprite.do_open()
				emit_signal("entered_door", destination_room, from_room)
		12:
			r = dialogues[14]
			emit_signal("used_axe")
			is_unlocked = true
		20, 21:
			r = dialogues[id]
	return r
