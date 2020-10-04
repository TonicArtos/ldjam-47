extends Node

class_name BaseRoom

const _dialogue_scene = preload("res://core/dialogue/dialogue.tscn")

var items = {
#	"key": KeyItem,
#	"battery": BatteryItem,
#	"axe": AxeItem,
#	"sag9000": Sag9kItem,
}

signal interact_complete()
signal pickup_item(item_id)

func _ready():
	$Player.connect("drop_item", self, "_on_drop_item")
	$Player.connect("interact_with", self, "_on_player_interaction")

func _exit_tree():
	$Player.disconnect("drop_item", self, "_on_drop_item")
	$Player.disconnect("interact_with", self, "_on_player_interaction")

func _on_player_interaction(target):
	# instance dialogue and link with player and target
	var dialogue = _dialogue_scene.instance()
	dialogue.connect("pickup_item", self, "_do_item_pickup")
	dialogue.connect("drop_item", self, "_on_drop_item")
	dialogue.connect("dialogue_complete", self, "_on_dialogue_complete")
	add_child(dialogue)
	$Dialogue.start(target, $Player)

func _do_item_pickup(item):
	emit_signal("pickup_item", item.id)
	item.queue_free()

func _on_drop_item(item_id, position):
	var item: Node2D = items.get(item_id).scene_instance()
	item.position = position
	add_child(item)

func _on_dialogue_complete():
	emit_signal("interact_complete")
