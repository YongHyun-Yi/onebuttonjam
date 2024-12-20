extends Node2D

var is_focus: bool = false
var focus_array: Array[Node2D]
var focus_array_idx: int = 0
var target: Node2D = null

signal normal_press
#signal double_press
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
		tween1.tween_property($sprite/left, "rotation_degrees", -20, .15)
		tween2.tween_property($sprite/right, "rotation_degrees", -160, .15)
	# 오므리기
	elif Input.is_action_just_released("ui_accept"):
		tween1.tween_property($sprite/left, "rotation_degrees", -90, .3)
		tween2.tween_property($sprite/right, "rotation_degrees", -90, .3)
		if is_focus == true:
			is_focus = false
			get_tree().paused = false
			$FocusTimer.stop()
			focus_array_idx = 0
			AudioServer.set_bus_effect_enabled(0, 0, false)
			AudioServer.set_bus_effect_enabled(0, 1, false)
		if target != null:
			$attack_area/CollisionShape2D.shape.b = global_position - target.global_position
			$attack_line.points[1] = $attack_area/CollisionShape2D.shape.b
			$attack_area/CollisionShape2D.disabled = false
			global_position = target.global_position
			# 화면 밖으로 나가지 않도록 보정
			global_position.x = clamp(global_position.x, 0, get_viewport().size.x)
			global_position.y = clamp(global_position.y, 0, get_viewport().size.y)
			await get_tree().create_timer(0.2).timeout
			$attack_area/CollisionShape2D.disabled = true
	# 가위의 attack_area는 탭을 놓을때 토글된다

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 가위가 바라볼 대상, 단 하나만 추적한다
	# 타겟이 사라지면 오버랩 되어있는것들 중 가장 가까운 것만 추적한다
	if not is_focus and $detect_area.has_overlapping_bodies():
		var papers: Array[Node2D] = $detect_area.get_overlapping_bodies()
		var nearest_paper = find_nearest_paper(papers)
		if target != null:
			target.untargetted()
		target = nearest_paper
		if target != null:
			target.targetted()
	#else:
		#if global_position.distance_to(target.global_position) > global_position.distance_to(nearest_paper.global_position):
			#target.untargetted()
			#target = nearest_paper
			#target.targetted()
	
	# 타겟이 존재하면 바라볼 방향을 보간한다
	if target != null:
		var rot_deg = rad_to_deg(global_position.angle_to_point(target.global_position))
		rot_deg = lerp($sprite.rotation_degrees, rot_deg, .2)
		$sprite.rotation_degrees = rot_deg
		$target_line.points[1] = target.global_position - global_position
	else:
		$target_line.points[1] = Vector2.ZERO
	
	$attack_line.points[1] = lerp($attack_line.points[1], Vector2.ZERO, 0.1)
	pass

#func normal_pressed() -> void:
	#emit_signal("normal_press")
	#print("normal press")
	#pass

#func double_pressed() -> void:
	#emit_signal("double_press")
	#pass

#func long_pressed() -> void:
	#emit_signal("long_press")
	#print("long press")
	#pass

func to_focus_mode(PaperArr: Array) -> void:
	is_focus = true
	var paper_arr: Array[Node2D] = []
	for paper in PaperArr:
		paper_arr.push_back(paper)
	# 집중모드 진입시에만 목록 갱신
	#focus_array = $focus_area.get_overlapping_bodies()
	focus_array = paper_arr
	$FocusTimer.start()
	AudioServer.set_bus_effect_enabled(0, 0, true)
	AudioServer.set_bus_effect_enabled(0, 1, true)
	pass

# 여기서 attack area를 toggle한다
# state별 움직임을 구현한다
func tap_handler() -> void:
	# target을 향해 순간이동한다
	# collision shape를 잠시 토글한다
	# 시그널 사용보다는 여기서 메소드를 직접 호출한다
	pass

# 공격 범위용 area, 여러 대상을 추적한다
# 무조건 범위 공격으로 변경
func _attack_area_body_entered(body: Node2D) -> void:
	# 새 목표에 공격 관련 signal을 connect 한다
	#normal_press.connect(body.normal_pressed)
	#double_press.connect(body.double_pressed)
	#long_press.connect(body.long_pressed)
	body.normal_pressed()
	if body == target:
		target = null
		#print("need target update")
	pass # Replace with function body.

# 공격 범위에서 나가면 관련 시그널을 모두 disconnect 한다
func _on_attack_area_body_exited(body: Node2D) -> void:
	#normal_press.disconnect(body.normal_pressed)
	#double_press.disconnect(body.double_pressed)
	#long_press.disconnect(body.long_pressed)
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


func _on_focus_timer_timeout() -> void:
	if focus_array.size() > 0 && is_focus == true:
		target = focus_array[focus_array_idx]
		#print(target.global_position)
		focus_array_idx += 1
		if focus_array_idx >= focus_array.size():
			focus_array_idx = 0
	pass # Replace with function body.
