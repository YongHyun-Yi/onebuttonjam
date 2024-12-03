extends CharacterBody2D
class_name Paper

@export var score: int = 10
@export var speed: float = 5.0
var direction: Vector2 = Vector2.ZERO
var target_position: Vector2

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var viewport_size = get_viewport().size
	var create_margin = 0
	# 생성 위치 화면 해상도에 맞춰 보정
	# modify position to screen border
	var wall_direction = randi() % 4
	if wall_direction == 0:
		global_position.x = 0 - create_margin
		global_position.y = randf_range(0 - create_margin, viewport_size.y + create_margin)
	elif wall_direction == 1:
		global_position.x = viewport_size.x + create_margin
		global_position.y = randf_range(0 - create_margin, viewport_size.y + create_margin)
	elif wall_direction == 2:
		global_position.x = randf_range(0 - create_margin, viewport_size.x + create_margin)
		global_position.y = 0 - create_margin
	else:
		global_position.x = randf_range(0 - create_margin, viewport_size.x + create_margin)
		global_position.y = viewport_size.y + create_margin
	
	direction = global_position.direction_to(target_position)
	rotation_degrees = rad_to_deg(direction.angle())
	$PaperParticle.rotation_degrees = -rotation_degrees

func _physics_process(delta: float) -> void:
	velocity = direction * speed

	move_and_slide()
	
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		score = 0
		normal_pressed()
		

func targetted() -> void:
	$before/ReferenceRect.border_color = Color.CRIMSON
	pass

func untargetted() -> void:
	$before/ReferenceRect.border_color = Color.BLACK
	pass

func normal_pressed() -> void:
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$PaperParticle.emitting = true
	get_node("/root/Main").remove_paper(self, score)
	$sfx.play()
	pass

func double_pressed() -> void:
	pass

func long_pressed() -> void:
	pass


func _on_paper_particle_finished() -> void:
	queue_free()
