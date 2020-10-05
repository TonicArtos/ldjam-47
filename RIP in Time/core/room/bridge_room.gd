extends BaseRoom

const Monster = preload("res://core/monster/monster_left.tscn")

func enter_from(from: String, player: PlayerState, animate_door: bool = false):
	_enter_player(player)
	match from:
		"LinkRoom":
			player.set_position(RIGHT_ENTER_POS)

var dialogues = {
	0 : Story.Message.new("look at bridge room", [Story.default_done()]),
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
	$Capsule5.connect("occupant_waking_up", self, "_occupant_waking")
	$Capsule6.connect("occupant_waking_up", self, "_occupant_waking")
	$Gun.connect("picked_up_gun", self, "_picked_up_gun")
	$LinkDoor.connect("entered_door", self, "_queue_enter_room")
	$Computer.connect("picked_up_key", self, "_picked_up_key")
	$MonsterTimer.connect("timeout", self, "_spawn_monster")

func _enter_tree():
	if get_parent().monster_unleashed:
		$MonsterTimer.start(3)

func _spawn_monster():
	var monster = Monster.instance()
	monster.position = RIGHT_ENTER_POS
	add_child(monster)
	move_child(camera, get_child_count())
