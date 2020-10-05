extends BaseRoom

func enter_from(from: String, player: PlayerState, animate_door: bool = false):
	_enter_player(player)
	match from:
		"LinkRoom":
			player.set_position(BG_ENTER_POS)

var dialogues = {
	0 : Story.Message.new("look at reactor room", [Story.default_done()]),
}

func get_dialogue(id: int, item):
	if id == 90:
		return item.get_dialogue(id, item)
	
	var r = dialogues[id]
	if id == 0:
		if item != null:
			r.options = [item.get_look_at_option(), Story.default_done()]
		else:
			r.options = [Story.default_done()]
	return r

func _ready():
	$LinkDoor.connect("entered_door", self, "_queue_enter_room")
	$Reactor.connect("contaminant_released", self, "_contaminant_released")
	$Reactor.connect("used_key", self, "_used_item")

func _contaminant_released():
	pass
