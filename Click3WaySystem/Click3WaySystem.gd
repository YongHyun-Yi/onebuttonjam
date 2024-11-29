extends Node

# Constants for detection thresholds
const LONG_TAP_TIME = 0.35   # Minimum hold time for long tap

signal normal_press
#signal double_press
signal long_press

# Variables to track touch states
var is_tapping: bool = false
var tap_duration: float = 0.0

func _process(delta):
	if is_tapping == true && tap_duration < LONG_TAP_TIME:
		tap_duration += delta
	
	if Input.is_action_just_pressed("ui_accept"):
		is_tapping = true
	elif Input.is_action_just_released("ui_accept"):
		# 싱글 탭
		if tap_duration < LONG_TAP_TIME:
			emit_signal("normal_press")
		# 롱 탭
		else:
			emit_signal("long_press")
		is_tapping = false
		tap_duration = 0.0
