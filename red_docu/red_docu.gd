extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	global_position = Vector2(rng.randf_range(-250, 1250), rng.randf_range(-200, 850))
	rotation_degrees = rng.randf_range(-360 * 2 , 360 * 2)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "position", Vector2.ZERO, .4)
	tween1.set_ease(Tween.EASE_OUT)
	tween1.set_trans(Tween.TRANS_QUART)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "rotation_degrees", 0, .4)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_EXPO)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func normal_press() -> void:
	print("Right!")
	pass

func double_press() -> void:
	print("Wrong!")
	pass

func long_press() -> void:
	print("Wrong!")
	pass
