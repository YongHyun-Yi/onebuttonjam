extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func _on_credit_button_button_up() -> void:
	$Credit.show()
	pass # Replace with function body.


func _on_credit_close_button_button_up() -> void:
	$Credit.hide()
	pass # Replace with function body.
