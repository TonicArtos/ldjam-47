extends Node2D

class_name FpsPrinter

const TIMER_LIMIT = 1.0
var timer = 0.0

func _process(delta):
	timer += delta
	if timer > TIMER_LIMIT:
		timer = 0.0
		print("fps: " + str(Engine.get_frames_per_second()))
