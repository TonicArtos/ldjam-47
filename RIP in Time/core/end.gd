extends Node2D

class_name EndScreen

var player_died: bool
var occupants_waking = []

func _ready():
	$Control.margin_top = 600

func _physics_process(delta):
	$Control.margin_top -= 20 * delta
