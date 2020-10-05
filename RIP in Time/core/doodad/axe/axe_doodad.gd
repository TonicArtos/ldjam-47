tool
extends Node2D

class_name AxeDoodad

func is_doodad():
	pass

export var has_axe = false

func set_has_axe(val):
	has_axe = val
	$Sprite2.visible = has_axe

signal picked_up_axe()

func _process(delta):
	if Engine.editor_hint:
		$Sprite2.visible = has_axe

func _ready():
	$Sprite2.visible = has_axe
	
var dialogues = {
	0 : Story.Message.new("axe holder with axe", [Story.Option.new(1, "take axe"), Story.default_done()]),
	1 : Story.Message.new("axe holder without axe", [Story.default_done()]),
	2 : Story.Message.new("take axe", [Story.Option.new(0, "back")]),
}

func get_dialogue(id: int, item):
	var r
	match id:
		0:
			id = 0 if has_axe else 1
			r = dialogues[id]
		1:
			r = dialogues[2]
			emit_signal("picked_up_axe")
			has_axe = false
			$Sprite2.visible = false
	return r
