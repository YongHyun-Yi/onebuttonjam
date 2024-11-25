extends Node2D

var docu_timer_rng = RandomNumberGenerator.new()
var docu_type_rng = RandomNumberGenerator.new()

@onready var docu_timer = get_node("Timer")
@export var docu_types : Array[PackedScene]
var docu_arr: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	docu_timer_rng.randomize()
	docu_type_rng.randomize()
	docu_timer.wait_time = docu_timer_rng.randf_range(0.7, 1.2)
	for i in 5:
		var docu_type = docu_type_rng.randi_range(0, 2)
		var docu_ins = docu_types[docu_type].instantiate()
		docu_arr.push_back(docu_ins)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var docu_arr_items: String
	for i in docu_arr.size():
		docu_arr_items += docu_arr[i].name + " "
	$docu_arr.text = docu_arr_items
	pass


func _on_timer_timeout() -> void:
	docu_timer.wait_time = docu_timer_rng.randf_range(0.7, 1.2)
	var tmp_docu = docu_arr.pop_front()
	$DocuHolder.add_child(tmp_docu)
	var docu_type = docu_type_rng.randi_range(0, 2)
	var docu_ins = docu_types[docu_type].instantiate()
	docu_arr.push_back(docu_ins)
