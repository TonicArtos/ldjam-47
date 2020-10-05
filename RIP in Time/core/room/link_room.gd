extends BaseRoom

func enter_from(from: String, player: PlayerState, animate_door: bool = false):
	_enter_player(player)
	player.change_state("idle")
	match from:
		"RipDriveRoom":
			if animate_door:
				$RipDoor.close_door()
			player.set_position(RIGHT_ENTER_POS)
		"ReactorRoom":
			player.set_position(BG_ENTER_POS)
		"BridgeRoom":
			player.set_position(LEFT_ENTER_POS)

var dialogues = {
	0 : Story.Message.new("look at link room", [Story.default_done()]),
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
	$Capsule1.connect("occupant_waking_up", self, "_occupant_waking")
	$Capsule2.connect("occupant_waking_up", self, "_occupant_waking")
	$Capsule3.connect("occupant_waking_up", self, "_occupant_waking")
	$Capsule4.connect("occupant_waking_up", self, "_occupant_waking")
	$Axe.connect("picked_up_axe", self, "_picked_up_axe")
	$BridgeDoor.connect("entered_door", self, "_queue_enter_room")
	$BridgeDoor.connect("used_axe", self, "_used_item")
	$RipDoor.connect("entered_door", self, "_queue_enter_room")
	$ReactorDoor.connect("entered_door", self, "_queue_enter_room")
	$ReactorDoor.connect("used_axe", self, "_used_item")
	
func _used_battery():
	player.carried_item = null