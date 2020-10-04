extends BaseRoom

var dialogues = {
	0 : Story.Message.new("look at room1", [Story.default_done()]),
	1 : Story.Message.new("msg from future1", [Story.Option.new(2, "continue")]),
	2 : Story.Message.new("msg from future2", [Story.default_done()]),
}

const RipEffect = preload("res://core/effect/rip_effect.tscn")

func get_dialogue(id: int, item):
	return dialogues[id]

func _ready():
	$RipTimer.connect("timeout", self, "_message_from_the_future")

func start_intro():
	player.change_state("intro")

func start_loop():
	player.change_state("use")
	_message_from_the_future()

func _message_from_the_future():
	$Camera.start_shake(1, 0.02, 3)
	$Camera.start_flash(0.15, 0.8, 0.15)
	var rip_effect = RipEffect.instance()
	rip_effect.set_position(Vector2(540, 336))
	rip_effect.play()
	add_child(rip_effect)
	
	var dialogue = _dialogue_scene.instance()
	dialogue.connect("pickup_item", self, "_do_item_pickup")
	dialogue.connect("drop_item", self, "_on_drop_item")
	dialogue.connect("dialogue_complete", self, "_on_dialogue_complete")
	add_child(dialogue)
	$Dialogue.start(self, player, 1)
	if get_parent().key_fob_delivered:
		pass

const LINK_ENTER_POS = Vector2(172, 400)

func enter_from(from: String, player: PlayerState):
	_enter_player(player)
	match from:
		"link":
			player.set_position(LINK_ENTER_POS)
