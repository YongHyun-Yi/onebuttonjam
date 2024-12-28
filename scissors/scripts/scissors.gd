extends Area2D

var velocity: Vector2 = Vector2.ZERO
var isMove: bool = false
var direction: Vector2 = Vector2.ZERO
var targetPosition: Vector2 = Vector2.ZERO

@export var max_speed: float = 1000.0
@export var min_speed: float = 200.0
@export var max_distance: float = 100.0

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		isMove = true
		targetPosition = event.position
		direction = global_position.direction_to(event.position).normalized()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if isMove:
		var distance = abs(global_position.distance_to(targetPosition))
		distance = min(distance, max_distance)
		var speed = max(min_speed, max_speed * (distance / max_distance))
		velocity = direction * speed * delta
		$sprite.rotation_degrees = lerp($sprite.rotation_degrees, rad_to_deg(global_position.angle_to_point(targetPosition)), .4) 
		if distance < 10:
			isMove = false
			velocity = Vector2.ZERO

	global_position += velocity
