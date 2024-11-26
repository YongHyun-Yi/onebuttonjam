extends Node

var long_pressed = false
var normal_pressed = false

var once_pressed = false
var press_time = 0.0
var double_press_time = 0.02
var long_press_time = 0.3

signal normal_press
signal double_press
signal long_press

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

# 도장 입력시스템 구현
# 시간에 상관없이 한번만 누를경우 한 번 누르기
# 일정시간 이상 눌렀다가 떼면 꾹 누르기
# 짧은 시간에 두 번 누를경우 두 번 누르기
# 한 번 누르고나서 짧은 시간안에 다시 누르면 두 번 누르기
# 꾹 누르기용 타이머, 두 번 누르기용 타이머 따로 만들기
# 한 번 누르기와 두 번 누르기를 어떻게 구분하는지?
func _process(delta: float) -> void:
	$CanvasLayer/ProgressBar3.value = press_time
	if press_time != 0.0:
		press_time += delta
	
	if press_time >= double_press_time:
		once_pressed = false
		#print("normal press!!")
	
	if Input.is_action_just_pressed("ui_accept"):
		$long_press.start()
		if once_pressed == true:
			if press_time < double_press_time:
				once_pressed = false
				press_time = 0
				print("double press!!")
		else:
			once_pressed = true
			press_time = delta
			#print("normal press!!")
	
	
	
	if Input.is_action_just_released("ui_accept"):
		#if long_pressed == true:
			#emit_signal("long_press")
			#print("Long Press!")
			#long_pressed = false
		#else:
			#$long_press.stop()
			#if normal_pressed == false:
				#normal_pressed = true
				#$double_press.start()
			#else:
				#emit_signal("double_press")
				#print("Double Press!")
				#normal_pressed = false
				#$double_press.stop()
		if press_time >= long_press_time:
			print("long press!!")
			press_time = 0
	
	$CanvasLayer/ProgressBar.value = $long_press.time_left
	$CanvasLayer/ProgressBar2.value = $double_press.time_left
	pass


func _on_long_press_timeout() -> void:
	long_pressed = true
	pass # Replace with function body.


func _on_double_press_timeout() -> void:
	emit_signal("normal_press")
	#print("Normal Press!")
	normal_pressed = false
	pass # Replace with function body.
