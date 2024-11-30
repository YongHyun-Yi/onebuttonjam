extends CharacterBody2D

@export var score: int = -30
@export var speed: float = 5.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var viewport_size = get_viewport().size
	var create_margin = 200
	# 생성 위치 화면 해상도에 맞춰 보정
	global_position.x = randf_range(0 - create_margin, viewport_size.x + create_margin)
	global_position.y = randf_range(0 - create_margin, viewport_size.y + create_margin)
	
	direction = global_position.direction_to(get_node("/root/Main/Scissors").global_position)
	rotation_degrees = rad_to_deg(direction.angle())
	$PaperParticle.rotation_degrees = -rotation_degrees

func _physics_process(delta: float) -> void:
	velocity = direction * speed

	move_and_slide()

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
	get_node("/root/Main").update_score(score)
	pass

func double_pressed() -> void:
	pass

func long_pressed() -> void:
	pass


func _on_paper_particle_finished() -> void:
	queue_free()
	pass # Replace with function body.
