tool
extends Node2D

class_name Capsule

func is_doodad():
	pass

export(String) var human_name = ""
export(String) var journal_entry = ""
export(bool) var is_active = false

signal capsule_activate(human_name)

func _process(delta):
	if Engine.editor_hint:
		if is_active:
			pass

func _ready():
	if is_active:
			pass
	
var dialogues = {
	0 : Story.Message.new(human_name, [Story.Option.new(1, "view journal entry"), Story.Option.new(2, "start wake cycle"), Story.default_done()]),
	1 : Story.Message.new(journal_entry, [Story.Option.new(0, "back")]),
	2 : Story.Message.new("start wake cycle", [Story.Option.new(0, "back")]),
	3 : Story.Message.new(human_name+"_waking", [Story.Option.new(1, "view journal entry"), Story.default_done()]),
}

func get_dialogue(id: int, item):
	var r
	match id:
		0:
			if is_active:
				r = dialogues[0]
			else:
				r = dialogues[3]
		1:
			r = dialogues[1]
		2:
			is_active = true
			emit_signal("capsule_activate", human_name)
	return r
