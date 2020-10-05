extends BaseRoom


var dialogues = {
	0 : Story.Message.new("look at room1", [Story.default_done()]),
	1 : Story.Message.new("msg from future1", [Story.Option.new(2, "continue")]),
	2 : Story.Message.new("msg from future2", [Story.default_done()]),
	3 : Story.Message.new("key delivered", [Story.Option.new(1, "continue")]),
}

const RipEffect = preload("res://core/effect/rip_effect.tscn")

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
	$RipTimer.connect("timeout", self, "_message_from_the_future")
	$RipDriveTerminal/RipDriveTerminal/Interactable.connect("rip_operated", self, "_rip_opened")
	$RipDriveTerminal/RipDriveTerminal/Interactable.connect("key_thrown_in_rip", self, "_key_thrown")
	$RipDriveTerminal/RipDriveTerminal/Interactable.connect("picked_up_battery", self, "_picked_up_battery")

func start_intro():
	player.change_state("intro")

func start_loop():
	player.change_state("use")
	_message_from_the_future()

func _message_from_the_future():
	$Camera.start_shake(1, 0.02, 3)
	$Camera.start_flash(0.15, 0.8, 0.15)
	var rip_effect = RipEffect.instance()
	rip_effect.set_position(Vector2(640, 266))
	add_child(rip_effect)
	move_child($Camera, get_child_count())
	rip_effect.play()
	
	var dialogue = _dialogue_scene.instance()
	dialogue.connect("pickup_item", self, "_do_item_pickup")
	dialogue.connect("drop_item", self, "_on_drop_item")
	dialogue.connect("dialogue_complete", self, "_on_dialogue_complete")
	add_child(dialogue)
	move_child($Camera, get_child_count())
	
	if get_parent().key_fob_delivered:
		$Dialogue.start(self, player, 3)
		var fob = KeyFob.instance()
		fob.set_position(Vector2(656, 442))
		fob.connect("item_picked_up", player, "on_item_picked_up")
		fob.connect("item_picked_up", self, "on_item_picked_up")
		add_child(fob)
		move_child(dialogue, get_child_count())
		move_child($Camera, get_child_count())
		pass
	else:
		$Dialogue.start(self, player, 1)

func _rip_opened():
	get_parent().get_node("BoomTimer").stop()
	get_parent().get_node("BoomTimer").start(10)
	$Camera.start_shake(1, 0.02, 3)
	$Camera.start_flash(0.15, 0.8, 0.15)
	var rip_effect = RipEffect.instance()
	rip_effect.set_position(Vector2(640, 266))
	add_child(rip_effect)
	move_child($Camera, get_child_count())
	rip_effect.only_once = false
	rip_effect.play()
	yield(get_tree().create_timer(4), "timeout")
	$Camera.start_shake(1, 0.02, 1)
	yield(get_tree().create_timer(4), "timeout")
	$Camera.start_shake(1, 0.02, 1)

func _key_thrown():
	get_parent().key_fob_delivered = true

const LINK_ENTER_POS = Vector2(172, 400)

func enter_from(from: String, player: PlayerState):
	_enter_player(player)
	match from:
		"link":
			player.set_position(LINK_ENTER_POS)
