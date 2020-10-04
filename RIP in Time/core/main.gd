extends Node2D

var key_fob_delivered = false

const RipDriveRoom = preload("res://core/room/rip_drive_room.tscn")
const CapsuleRoom = preload("res://core/room/rip_drive_room.tscn")
const BridgeRoom = preload("res://core/room/rip_drive_room.tscn")
const ReactorRoom = preload("res://core/room/rip_drive_room.tscn")
const Player = preload("res://core/player/player.tscn")

const BOOM_TIME: int = 168 #seconds
#const BOOM_TIME: int = 5 #seconds
const BOOM_DELAY = 2
const BOOM_WHITE_OUT_SPEED = 0.1
const FADE_SPEED = 0.2

var current_room: Node = null
var current_camera = null

var stored_rooms = {}

func _ready():
	$BoomTimer.connect("timeout", self, "_on_boom")
	_start_loop()

func _on_boom():
	current_room.get_node("Dialogue").queue_free()
	current_camera.start_shake(1, 0.02, BOOM_DELAY + BOOM_WHITE_OUT_SPEED * 4)
	current_camera.start_flash(0.15, 0.8, 0.15)
	yield(get_tree().create_timer(1), "timeout")
	current_camera.white_out(BOOM_WHITE_OUT_SPEED)
	yield(get_tree().create_timer(0.2), "timeout")
	$AudioStreamPlayer.stop()
	current_camera.fade_out(0.1)
	yield(get_tree().create_timer(2), "timeout")
	_start_loop()
	
func _start_loop():
	remove_child(current_room)
	current_room = RipDriveRoom.instance()
	add_child(current_room)
	yield(get_tree().create_timer(1), "timeout")
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(2), "timeout")
	current_camera = current_room.get_node("Camera")
	current_room.enter_from("link", Player.instance())
	current_room.start_intro()
	current_camera.fade_in(8)
	stored_rooms["RipDriveRoom"] = current_room
	yield(get_tree().create_timer(5), "timeout")
	current_room.start_loop()
	_start_boom_timer()

func _start_boom_timer():
	$BoomTimer.start(BOOM_TIME)

func _enter_room(room: String, from: String, player: PlayerState):
	var recalled = stored_rooms["RipDriveRoom"]
	current_camera.fade_out(0, FADE_SPEED)
	yield(get_tree().create_timer(FADE_SPEED), "timeout")
	current_room.remove_child(player)
	remove_child(current_room)
	if recalled == null:
		match room:
			"LinkRoom":
				current_room = CapsuleRoom.instance()
				stored_rooms["LinkRoom"] = current_room
			"BridgeRoom":
				current_room = BridgeRoom.instance()
				stored_rooms["BridgeRoom"] = current_room
			"ReactorRoom":
				current_room = ReactorRoom.instance()
				stored_rooms["ReactorRoom"] = current_room
	add_child(current_room)
	current_camera.fade_in(0, FADE_SPEED)
	yield(get_tree().create_timer(FADE_SPEED), "timeout")
	current_room.enter_from(from, player)
	current_camera = current_room.get_node("Camera")
