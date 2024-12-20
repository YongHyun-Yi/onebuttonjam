extends CharacterBody2D

#var isMove: bool = false
var direction: Vector2 = Vector2.ZERO
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		direction = global_position.direction_to(event.position).normalized()
		print("hi")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not isMove:
		#velocity += get_gravity() * delta
	velocity = direction * SPEED

	move_and_slide()
