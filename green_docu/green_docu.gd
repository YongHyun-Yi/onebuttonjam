extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func normal_press() -> void:
	print("Wrong!")
	pass

func double_press() -> void:
	print("Wrong!")
	pass

func long_press() -> void:
	print("Right!")
	pass
