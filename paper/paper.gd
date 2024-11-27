extends CharacterBody2D

@export var speed: float = 5.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	global_position.x = randf_range(0, 1152)
	global_position.y = randf_range(0, 648)
	
	direction = global_position.direction_to(get_node("/root/Main/Scissors").global_position)
	rotation_degrees = rad_to_deg(direction.angle())

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
	$before.hide()
	$after.show()
	$CollisionShape2D.disabled = true
	pass

func double_pressed() -> void:
	pass

func long_pressed() -> void:
	pass
