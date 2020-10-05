extends Node

class_name BaseRoom

const RIGHT_ENTER_POS = Vector2(788, 400)
const LEFT_ENTER_POS = Vector2(172, 400)
const BG_ENTER_POS = Vector2(232, 400)

const _dialogue_scene = preload("res://core/dialogue/dialogue.tscn")

const KeyFob = preload("res://core/item/key_fob/key_fob.tscn")
const Axe = preload("res://core/item/axe/axe.tscn")
const Gun = preload("res://core/item/gun/gun.tscn")
const Battery = preload("res://core/item/battery/battery.tscn")

var destination
var from

func _picked_up_battery():
	player.carried_item = Battery.instance()

func _picked_up_gun():
	player.carried_item = Gun.instance()

func _picked_up_axe():
	player.carried_item = Axe.instance()

func _picked_up_key():
	player.carried_item = KeyFob.instance()

func _used_item():
	player.carried_item = null

var player: PlayerState

signal interact_complete()
signal pickup_item(item_id)

func _enter_player(player: PlayerState):
	add_child(player)
	player.change_state("idle")
	move_child(camera, get_child_count())
	self.player = player
	player.connect("drop_item", self, "_on_drop_item")
	player.connect("interact_with", self, "_on_player_interaction")

func _exit_tree():
	player.disconnect("drop_item", self, "_on_drop_item")
	player.disconnect("interact_with", self, "_on_player_interaction")

func _on_player_interaction(target):
	# instance dialogue and link with player and target
	var dialogue = _dialogue_scene.instance()
	dialogue.connect("drop_item", self, "_on_drop_item")
	dialogue.connect("dialogue_complete", self, "_on_dialogue_complete")
	add_child(dialogue)
	$Dialogue.start(target, player)

func _on_drop_item(item):
	item.connect("item_picked_up", player, "on_item_picked_up")
	item.connect("item_picked_up", self, "on_item_picked_up")
	add_child(item)
	item.set_position(Vector2(player.position.x, item.get_floor_y_position()))
	move_child(camera, get_child_count())
	player.carried_item = null

func on_item_picked_up(item):
	remove_child(item)
	item.disconnect("item_picked_up", self, "on_item_picked_up")

func _queue_enter_room(dest: String, from: String):
	destination = dest
	self.from = from

signal go_to_room(dest, from, player)

func _on_dialogue_complete():
	emit_signal("interact_complete")
	if destination != null:
		var dest = destination
		destination = null
		emit_signal("go_to_room", dest, from, player)

func enter_from(from: String, player: PlayerState, animate_door: bool = false):
	pass

var camera: Node

func add_child(node: Node, readable: bool = false):
	.add_child(node, readable)
	if node.has_method("is_camera"):
		camera = node
	
func remove_child(node: Node):
	.remove_child(node)
	if node.has_method("is_camera"):
		camera = null
