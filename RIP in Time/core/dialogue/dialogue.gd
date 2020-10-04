extends Node

class_name Dialogue

signal drop_item(item)
signal pickup_item(item)
signal dialogue_complete()

const MenuEntry = preload("res://core/dialogue/menu_entry.tscn")
const Menu = preload("res://core/dialogue/menu.tscn")

var message_display: Label
var menu_holder: MarginContainer
var menu: DialogueMenu
var player
var target

const lower_chars_per_second: int = 80
const upper_chars_per_second: int = 180
const speed_threshold: int = 100
var show_characters: int
var max_characters: int

func _ready():
	message_display = get_node("Control/CenterContainer/HBoxContainer/Message9Patch/MessageMargins/Message")
	menu_holder = get_node("Control/CenterContainer/HBoxContainer/Menu9Patch/MenuMargins")

func start(target, player, initial_id: int = 0):
	self.target = target
	self.player = player
	_handle_message(target.get_dialogue(initial_id, player.carried_item))
	
func _physics_process(delta):
	if max_characters > show_characters:
		show_characters += delta * (lower_chars_per_second if max_characters < speed_threshold else upper_chars_per_second)
		message_display.visible_characters = show_characters
	
func _handle_message(message: Story.Message):
	message_display.set_text(Story.text[message.text_id])
	max_characters = message_display.text.length()
	show_characters = 0
	if menu != null:
		menu.disconnect("menu_entry_chosen", self, "_on_menu_entry_chosen")
	menu = Menu.instance()
	menu_holder.add_child(menu)
	menu.connect("menu_entry_chosen", self, "_on_menu_entry_chosen")
	for option in message.options:
		var entry = MenuEntry.instance()
		menu.add_entry(entry)
		entry.load_data(option.label, option.id)
	pass

func _on_menu_entry_chosen(id: int):
	if id == 100:
		emit_signal("dialogue_complete")
		self.queue_free()
	else:
		_handle_message(target.get_dialogue(id, player.carried_item))

# TODO:

# load in data from targets and carried items.
# populate menu
# step through text in message box with any key. Once done menu box shows.
# Add ui navigation for menu options.

# stuff needs to happen on menu options.
