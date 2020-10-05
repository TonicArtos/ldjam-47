extends Camera2D

class_name RoomCamera

onready var shake_length = $ShakeLength
onready var shake_period = $ShakePeriod
onready var tweener = $Tweener
onready var flash_image = $FlashSprite
onready var fade_image = $FadeSprite

var reset_speed = 0
var strength = 0
var flash_strength = 0.7
var is_shaking = false

func is_camera():
	pass

func _ready():
	shake_length.connect("timeout", self, "_on_timeout_shake")
	shake_period.connect("timeout", self, "_on_shake_wait")

func fade_in(speed):
	tweener.interpolate_property(
		fade_image,
		"modulate:a",
		1,
		0,
		speed,
		Tween.EASE_IN,
		Tween.EASE_OUT
	)
	tweener.start()

func fade_out(speed):
	tweener.interpolate_property(
		fade_image,
		"modulate:a",
		0,
		1,
		speed,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tweener.start()

func white_out(speed):
	tweener.interpolate_property(
		flash_image,
		"modulate:a",
		0,
		1,
		speed,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tweener.start()

func _on_timeout_shake():
	is_shaking = false
	shake_period.stop()
	_reset_camera()
	
func _on_shake_wait():
	if is_shaking:
		tweener.interpolate_property(
			self,
			"offset",
			offset,
			Vector2(rand_range(-strength, strength), rand_range(-strength, strength)),
			reset_speed,
			Tween.TRANS_SINE,
			Tween.EASE_OUT
		)
		tweener.start()

func _reset_camera():
	tweener.interpolate_property(
		self,
		"offset",
		offset,
		Vector2(0, 0),
		reset_speed,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tweener.start()

func start_shake(time, speed, strength):
	is_shaking = true
	self.strength = strength
	self.reset_speed = speed
	shake_length.start(time)
	shake_period.start(speed)

func start_flash(speed, strength, delay):
	yield(get_tree().create_timer(delay), "timeout")
	tweener.interpolate_property(
		flash_image,
		"modulate:a",
		0,
		strength,
		speed,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tweener.start()
	
	yield(get_tree().create_timer(speed), "timeout")
	tweener.interpolate_property(
		flash_image,
		"modulate:a",
		strength,
		0,
		speed,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	tweener.start()
