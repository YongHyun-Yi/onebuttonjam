extends Node2D

var target: Node2D = null
@export var multiple_attack = true

signal normal_press
signal double_press
signal long_press

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# 가위 모션
func _unhandled_input(event: InputEvent) -> void:
	var tween1 = get_tree().create_tween()
	tween1.set_ease(Tween.EASE_OUT)
	tween1.set_trans(Tween.TRANS_QUART)
	
	var tween2 = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_QUART)
	
	# 벌리기
	if Input.is_action_just_pressed("ui_accept"):
		tween1.tween_property($left, "rotation_degrees", -20, .15)
		tween2.tween_property($right, "rotation_degrees", -160, .15)
	# 오므리기
	elif Input.is_action_just_released("ui_accept"):
		tween1.tween_property($left, "rotation_degrees", -90, .3)
		tween2.tween_property($right, "rotation_degrees", -90, .3)
	
	# 가위의 attack_area는 탭을 놓을때 토글된다

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 가위가 바라볼 대상, 단 하나만 추적한다
	# 타겟이 사라지면 오버랩 되어있는것들 중 가장 가까운 것만 추적한다
	if $detect_area.has_overlapping_bodies():
		var papers: Array[Node2D] = $detect_area.get_overlapping_bodies()
		var nearest_paper = find_nearest_paper(papers)
		if target == null:
			target = nearest_paper
			target.targetted()
		else:
			if global_position.distance_to(target.global_position) > global_position.distance_to(nearest_paper.global_position):
				target.untargetted()
				target = nearest_paper
				target.targetted()
	
	# 타겟이 존재하면 바라볼 방향을 보간한다
	if target != null:
		var rot_deg = rad_to_deg(global_position.angle_to_point(target.global_position))
		rot_deg = lerp(rotation_degrees, rot_deg, .2)
		rotation_degrees = rot_deg
	pass

func normal_pressed() -> void:
	emit_signal("normal_press")
	print("normal press")
	pass

#func double_pressed() -> void:
	#emit_signal("double_press")
	#pass

func long_pressed() -> void:
	emit_signal("long_press")
	print("long press")
	pass

# 공격 범위용 area, 여러 대상을 추적한다
# 무조건 범위 공격으로 변경
func _attack_area_body_entered(body: Node2D) -> void:
	# 새 목표에 공격 관련 signal을 connect 한다
	normal_press.connect(body.normal_pressed)
	double_press.connect(body.double_pressed)
	long_press.connect(body.long_pressed)
	pass # Replace with function body.

# 공격 범위에서 나가면 관련 시그널을 모두 disconnect 한다
func _on_attack_area_body_exited(body: Node2D) -> void:
	normal_press.disconnect(body.normal_pressed)
	double_press.disconnect(body.double_pressed)
	long_press.disconnect(body.long_pressed)
	pass # Replace with function body.

func find_nearest_paper(papers: Array[Node2D]) -> Node2D:
	var min_distance = 9999
	var nearest_paper = null
	for paper in papers:
		var distance = abs(global_position.distance_to(paper.global_position))
		if min_distance > distance:
			min_distance = distance
			nearest_paper = paper
	return nearest_paper


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
	pass # Replace with function body.
