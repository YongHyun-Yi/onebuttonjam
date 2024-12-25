extends CharacterBody2D

var isMove: bool = false
var direction: Vector2 = Vector2.ZERO
var targetPosition: Vector2 = Vector2.ZERO
const SPEED = 1200.0
const GRAVITY_MAX = 130.0


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		isMove = true
		targetPosition = event.position
		direction = global_position.direction_to(event.position).normalized()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if isMove:
		velocity = direction * SPEED
		if abs(global_position.distance_to(targetPosition)) < 10:
			isMove = false
			velocity = Vector2.ZERO
	else:
		velocity += get_gravity() * delta
		if velocity.y > GRAVITY_MAX:
			velocity.y = GRAVITY_MAX

	move_and_slide()
