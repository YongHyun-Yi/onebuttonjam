extends Node

# Constants for detection thresholds
const LONG_TAP_TIME = 0.35   # Minimum hold time for long tap

#signal normal_press
#signal double_press
#signal long_press
signal to_long_tap(PaperArr)

# Variables to track touch states
var is_tapping: bool = false
var tap_duration: float = 0.0

func _process(delta):
	if is_tapping == true && tap_duration < LONG_TAP_TIME:
		if tap_duration + delta >= LONG_TAP_TIME:
			emit_signal("to_long_tap", get_parent().PaperArr)
		tap_duration += delta
	
	if Input.is_action_just_pressed("ui_accept"):
		is_tapping = true
	elif Input.is_action_just_released("ui_accept"):
		is_tapping = false
		tap_duration = 0.0
