extends Node2D

var target = null

signal normal_press
signal double_press
signal long_press

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if target != null:
		#look_at(target.global_position)
	look_at(get_global_mouse_position())
	pass

func normal_pressed() -> void:
	emit_signal("normal_press")
	pass

func double_pressed() -> void:
	emit_signal("double_press")
	pass

func long_pressed() -> void:
	emit_signal("long_press")
	pass

# area에 들어온 종 하나만 추적한다
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body entered!")
	# 이전에 추적중인 종가 있다면 signal을 모두 disconnect 한다
	if target != null:
		normal_press.disconnect(target.normal_pressed)
		double_press.disconnect(target.double_pressed)
		long_press.disconnect(target.long_pressed)
	
	# 새 목표 문서에 signal을 connect
	target = body
	normal_press.connect(target.normal_pressed)
	double_press.connect(target.double_pressed)
	long_press.connect(target.long_pressed)
	
	# 오버랩 되어있는경우
	# 가장 위의 종이가 잘리고나서 밑에 있던
	# 이전 종이에도 효과가 미치도록 해야한다
	pass # Replace with function body.
