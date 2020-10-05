extends Node2D

var key_fob_delivered = false

const RipDriveRoom = preload("res://core/room/rip_drive_room.tscn")
const LinkRoom = preload("res://core/room/link_room.tscn")
const BridgeRoom = preload("res://core/room/bridge_room.tscn")
const ReactorRoom = preload("res://core/room/reactor_room.tscn")
const Player = preload("res://core/player/player.tscn")
const RoomCamera = preload("res://core/camera/room_camera.tscn")

const BOOM_TIME: int = 168 #seconds
#const BOOM_TIME: int = 5 #seconds
const BOOM_DELAY = 2
const BOOM_WHITE_OUT_SPEED = 0.1
const FADE_SPEED = 0.5

var current_room: Node = null

var camera: RoomCamera
var player: PlayerState

var stored_rooms = {}

func _ready():
	$BoomTimer.connect("timeout", self, "_on_boom")
	#_start_loop()
	_test_room("LinkRoom", "RipDriveRoom")

func _on_boom():
	var dialogue = current_room.get_node("Dialogue")
	if dialogue != null:
		dialogue.queue_free()
	camera.start_shake(1, 0.02, BOOM_DELAY + BOOM_WHITE_OUT_SPEED * 4)
	camera.start_flash(0.15, 0.8, 0.15)
	yield(get_tree().create_timer(1), "timeout")
	camera.white_out(BOOM_WHITE_OUT_SPEED)
	yield(get_tree().create_timer(0.2), "timeout")
	$AudioStreamPlayer.stop()
	camera.fade_out(0.1)
	yield(get_tree().create_timer(2), "timeout")
	_start_loop()

func _test_room(room: String, from: String):
	camera = RoomCamera.instance()
	player = Player.instance()
	current_room = RipDriveRoom.instance()
	add_child(current_room)
	current_room.add_child(camera)
	current_room.enter_from("LinkRoom", player)
	_enter_room(room, from, player)

func _start_loop():
	camera = RoomCamera.instance()
	player = Player.instance()
	remove_child(current_room)
	current_room = RipDriveRoom.instance()
	stored_rooms = {}
	add_child(current_room)
	current_room.add_child(camera)
	current_room.connect("go_to_room", self, "_enter_room")
	yield(get_tree().create_timer(1), "timeout")
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(2), "timeout")
	current_room.enter_from("LinkRoom", player)
	current_room.start_intro()
	camera.fade_in(8)
	stored_rooms["RipDriveRoom"] = current_room
	yield(get_tree().create_timer(5), "timeout")
	current_room.start_loop()
	_start_boom_timer()

func _start_boom_timer():
	$BoomTimer.start(BOOM_TIME)

func _enter_room(room: String, from: String, player: PlayerState):
	var recalled = stored_rooms[room] if stored_rooms.has(room) else null
	camera.fade_out(FADE_SPEED)
	yield(get_tree().create_timer(FADE_SPEED), "timeout")
	current_room.disconnect("go_to_room", self, "_enter_room")
	current_room.remove_child(player)
	current_room.remove_child(camera)
	remove_child(current_room)
	if recalled == null:
		match room:
			"RipDriveRoom":
				recalled = RipDriveRoom.instance()
				stored_rooms["RipDriveRoom"] = recalled
			"LinkRoom":
				recalled = LinkRoom.instance()
				stored_rooms["LinkRoom"] = recalled
			"BridgeRoom":
				recalled = BridgeRoom.instance()
				stored_rooms["BridgeRoom"] = recalled
			"ReactorRoom":
				recalled = ReactorRoom.instance()
				stored_rooms["ReactorRoom"] = recalled
	current_room = recalled
	add_child(current_room)
	current_room.add_child(camera)
	current_room.connect("go_to_room", self, "_enter_room")
	camera.fade_in(FADE_SPEED)
	current_room.enter_from(from, player, true)
