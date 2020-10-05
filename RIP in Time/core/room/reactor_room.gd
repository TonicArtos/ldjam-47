extends BaseRoom

const Monster = preload("res://core/monster/monster_left.tscn")
const MONSTER_START = Vector2(580, 180)

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
	get_parent().set_monster_unleashed(true)
	var monster = Monster.instance()
	monster.position = MONSTER_START
	add_child(monster)
	move_child(camera, get_child_count())
