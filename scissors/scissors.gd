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
	if target != null:
		look_at(target.global_position)
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

# area에 들어온 문서 하나만 추적한다
func _on_area_2d_area_entered(area: Area2D) -> void:
	# 이전에 추적중인 문서가 있다면 signal을 모두 disconnect 한다
	if target != null:
		normal_press.disconnect(target.normal_press)
		double_press.disconnect(target.double_press)
		long_press.disconnect(target.long_press)
	
	# 새 목표 문서에 signal을 connect
	target = area.get_parent()
	normal_press.connect(target.normal_press)
	double_press.connect(target.double_press)
	long_press.connect(target.long_press)
	pass # Replace with function body.
