tool
extends Node2D

class_name GunDoodad

func is_doodad():
	pass

export var has_gun = false

func set_has_gun(val):
	has_gun = val
	$Sprite2.visible = has_gun

signal picked_up_gun()

func _process(delta):
	if Engine.editor_hint:
		$Sprite2.visible = has_gun

func _ready():
	$Sprite2.visible = has_gun
	
var dialogues = {
	0 : Story.Message.new("gun holder with gun", [Story.Option.new(1, "take gun"), Story.default_done()]),
	1 : Story.Message.new("gun holder without gun", [Story.default_done()]),
	2 : Story.Message.new("take gun", [Story.Option.new(0, "back")]),
	3 : Story.Message.new("already carrying item", [Story.Option.new(0, "back")]),
}

func get_dialogue(id: int, item):
	var r
	match id:
		0:
			id = 0 if has_gun else 1
			r = dialogues[id]
		1:
			if item == null:
				r = dialogues[2]
				emit_signal("picked_up_gun")
				has_gun = false
				$Sprite2.visible = false
			else:
				r = dialogues[3]
	return r
