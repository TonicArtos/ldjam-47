extends BaseRoom

var dialogues = {
	0 : Story.Message.new("look at room1", [Story.default_done()]),
}

func get_dialogue(id: int, item):
	return dialogues[0]
