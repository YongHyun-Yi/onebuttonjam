extends Node2D

var target: Node2D = null

signal normal_press
signal double_press
signal long_press

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 가위가 바라볼 대상, 단 하나만 추적한다
	# 오버랩 되어있는것들 중 가장 가까운 것만 추적한다
	if $detect_area.has_overlapping_bodies():
		var papers: Array[Node2D] = $detect_area.get_overlapping_bodies()
		var min_distance: int
		if target != null:
			min_distance = abs(global_position.distance_to(target.global_position))
		else:
			min_distance = 9999
		for p in papers:
			var distance = abs(global_position.distance_to(p.global_position))
			if min_distance > distance:
				min_distance = distance
				target = p
		
	
	if target != null:
		var rot_deg = rad_to_deg(global_position.angle_to_point(target.global_position))
		rot_deg = lerp(rotation_degrees, rot_deg, .2)
		rotation_degrees = rot_deg
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

# 공격 범위용 area, 여러 대상을 추적한다
func _attack_area_body_entered(body: Node2D) -> void:
	# 새 목표에 공격 관련 signal을 connect 한다
	normal_press.connect(body.normal_pressed)
	double_press.connect(body.double_pressed)
	long_press.connect(body.long_pressed)
	
	# 오버랩 되어있는경우
	# 가장 위의 종이가 잘리고나서 밑에 있던
	# 이전 종이에도 효과가 미치도록 해야한다
	# 범위공격 or 단일공격 - 토글 가능하게, 테스트용
	pass # Replace with function body.

# 공격 범위에서 나가면 관련 시그널을 모두 disconnect 한다
func _on_attack_area_body_exited(body: Node2D) -> void:
	normal_press.disconnect(body.normal_pressed)
	double_press.disconnect(body.double_pressed)
	long_press.disconnect(body.long_pressed)
	pass # Replace with function body.
