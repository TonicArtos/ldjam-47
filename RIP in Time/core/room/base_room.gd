extends Node

class_name BaseRoom

const _dialogue_scene = preload("res://core/dialogue/dialogue.tscn")

var items = {
#	"key": KeyItem,
#	"battery": BatteryItem,
#	"axe": AxeItem,
#	"sag9000": Sag9kItem,
}

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
	dialogue.connect("pickup_item", self, "_do_item_pickup")
	dialogue.connect("drop_item", self, "_on_drop_item")
	dialogue.connect("dialogue_complete", self, "_on_dialogue_complete")
	add_child(dialogue)
	$Dialogue.start(target, player)

func _do_item_pickup(item):
	emit_signal("pickup_item", item.id)
	item.queue_free()

func _on_drop_item(item_id, position):
	var item: Node2D = items.get(item_id).scene_instance()
	item.position = position
	add_child(item)

func _on_dialogue_complete():
	emit_signal("interact_complete")
