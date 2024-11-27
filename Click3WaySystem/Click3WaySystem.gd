extends Node

# Constants for detection thresholds
const DOUBLE_TAP_TIME = 0.17  # Maximum interval for double-tap detection
const LONG_TAP_TIME = 0.5   # Minimum hold time for long tap

signal normal_press
signal double_press
signal long_press

# Variables to track touch states
var tap_start_time = 0.0
var last_tap_time = -1.0
var is_tapping = false
var is_double_tap = false
var long_tap_triggered = false

func _process(delta):
	# Handle touch input using actions
	if Input.is_action_pressed("ui_accept"):
		if not is_tapping:
			# Start of a new tap
			is_tapping = true
			tap_start_time = Time.get_ticks_msec() / 1000.0
			long_tap_triggered = false
		else:
			# Check for long tap only if the touch is held
			var current_time = Time.get_ticks_msec() / 1000.0
			if (current_time - tap_start_time) >= LONG_TAP_TIME:
				long_tap_triggered = true  # Mark long tap as triggered
	elif Input.is_action_just_released("ui_accept"):
		# End of touch: determine the type of tap
		if is_tapping:
			var tap_duration = Time.get_ticks_msec() / 1000.0 - tap_start_time
			is_tapping = false
			
			if long_tap_triggered:
				# If it was a long tap, trigger the long tap handler
				emit_signal("long_press")
				print("long tap")
			else:
				# Otherwise, check for single or double tap
				_handle_tap()

	# Reset double-tap state after DOUBLE_TAP_TIME
	if last_tap_time > 0.0 and (Time.get_ticks_msec() / 1000.0 - last_tap_time) > DOUBLE_TAP_TIME:
		is_double_tap = false

func _handle_tap():
	var current_time = Time.get_ticks_msec() / 1000.0
	if last_tap_time > 0.0 and (current_time - last_tap_time) <= DOUBLE_TAP_TIME:
		# Double tap detected
		emit_signal("double_press")
		print("double tap")
		last_tap_time = -1.0  # Reset last tap time
		is_double_tap = true
	else:
		# Schedule single tap to be triggered after DOUBLE_TAP_TIME
		is_double_tap = false
		last_tap_time = current_time
		await get_tree().create_timer(DOUBLE_TAP_TIME).timeout
		if not is_double_tap:
			emit_signal("normal_press")
			print("single tap")
