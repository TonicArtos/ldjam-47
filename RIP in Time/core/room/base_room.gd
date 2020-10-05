extends Node

class_name BaseRoom

const _dialogue_scene = preload("res://core/dialogue/dialogue.tscn")

const KeyFob = preload("res://core/item/key_fob/key_fob.tscn")
const Axe = preload("res://core/item/axe/axe.tscn")
const Gun = preload("res://core/item/gun/gun.tscn")
const Battery = preload("res://core/item/battery/battery.tscn")

func _picked_up_battery():
	player.carried_item = Battery.instance()

func _picked_up_gun():
	player.carried_item = Gun.instance()

func _picked_up_axe():
	player.carried_item = Axe.instance()

func _picked_up_key():
	player.carried_item = KeyFob.instance()

var player: PlayerState

signal interact_complete()
signal pickup_item(item_id)

func _enter_player(player: PlayerState):
	add_child(player)
	move_child($Camera, get_child_count())
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
	move_child($Camera, get_child_count())
	player.carried_item = null

func on_item_picked_up(item):
	remove_child(item)
	item.disconnect("item_picked_up", self, "on_item_picked_up")

func _on_dialogue_complete():
	emit_signal("interact_complete")
