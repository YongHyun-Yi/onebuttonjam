extends CharacterBody2D

@export var speed: float = 5.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	#global_position.x = -500
	#global_position.x = 1500
	#global_position.y = -500
	#global_position.y = 1000
	pass

func _physics_process(delta: float) -> void:
	velocity = direction * speed

	move_and_slide()

func normal_pressed() -> void:
	$before.hide()
	$after.show()
	$CollisionShape2D.disabled = true
	pass

func double_pressed() -> void:
	pass

func long_pressed() -> void:
	pass
