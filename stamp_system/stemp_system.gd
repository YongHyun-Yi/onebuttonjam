extends Node

@export var confirm_stamp: PackedScene

var long_pressed = false
var normal_pressed = false
var target_docu = null

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
	if Input.is_action_just_pressed("ui_accept"):
		$long_press.start()
	
	if Input.is_action_just_released("ui_accept"):
		if long_pressed == true:
			emit_signal("long_press")
			create_stamp_mark()
			print("Long Press!")
			long_pressed = false
		else:
			$long_press.stop()
			if normal_pressed == false:
				normal_pressed = true
				$double_press.start()
			else:
				emit_signal("double_press")
				create_stamp_mark()
				print("Double Press!")
				normal_pressed = false
				$double_press.stop()
	
	$CanvasLayer/ProgressBar.value = $long_press.time_left
	$CanvasLayer/ProgressBar2.value = $double_press.time_left
	pass


func _on_long_press_timeout() -> void:
	long_pressed = true
	pass # Replace with function body.


func _on_double_press_timeout() -> void:
	emit_signal("normal_press")
	create_stamp_mark()
	print("Normal Press!")
	normal_pressed = false
	pass # Replace with function body.

# area에 들어온 문서 하나만 추적한다
# 이전에 추적중인 문서가 있다면 signal을 모두 disconnect 한다
func _on_area_2d_area_entered(area: Area2D) -> void:
	if target_docu != null:
		normal_press.disconnect(target_docu.normal_press)
		double_press.disconnect(target_docu.double_press)
		long_press.disconnect(target_docu.long_press)
	
	# 새 목표 문서에 signal을 connect
	target_docu = area.get_parent()
	normal_press.connect(target_docu.normal_press)
	double_press.connect(target_docu.double_press)
	long_press.connect(target_docu.long_press)
	pass # Replace with function body.

# 도장표시 생성
func create_stamp_mark():
	# 목표 문서가 있을경우에만 동작
	if target_docu != null:
		var stamp_mark = confirm_stamp.instantiate()
		# 위치와 각도 설정
		stamp_mark.global_position = abs($Area2D.global_position - target_docu.global_position) - ($Area2D/CollisionShape2D.shape.size / 2) - Vector2(6, 8)
		stamp_mark.rotation = -target_docu.rotation
		target_docu.add_child(stamp_mark)
