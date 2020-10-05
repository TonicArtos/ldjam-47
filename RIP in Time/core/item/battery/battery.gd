extends Area2D

const FLOOR_POSITION = 442

func is_item():
	pass

var dialogues = {
	0 : Story.Message.new(
		"look at battery", 
		[
			Story.Option.new(1, "pick up"),
			Story.default_done(),
		]
	),
	1 : Story.Message.new("pick up battery", [Story.default_done()]),
	2 : Story.Message.new("already carrying item", [Story.default_done()]),
	90 : Story.Message.new("carrying battery", [Story.Option.new(99, "drop"), Story.default_done()]),
}

func get_dialogue(id: int, item):
	var r
	match id:
		0:
			r = dialogues[0]
		1:
			if item == null:
				r = dialogues[1]
				get_parent().emit_signal("item_picked_up", get_parent())
			else:
				r = dialogues[2]
		90:
			r = dialogues[90]
	return r


func get_look_at_option():
	return Story.Option.new(90, "look at battery")
