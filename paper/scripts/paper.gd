extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var targetPosition: Vector2 = Vector2.ZERO
const SPEED = 1200.0
const GRAVITY_MAX = 130.0

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	if velocity.y > GRAVITY_MAX:
		velocity.y = GRAVITY_MAX
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Collided with: ", collision.get_collider().name)
