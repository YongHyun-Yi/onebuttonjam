extends Node2D

var PaperTimerRng = RandomNumberGenerator.new()
var PaperTypeRng = RandomNumberGenerator.new()

@onready var PaperTimer = get_node("Timer")
@export var PaperTypes : Array[PackedScene]
var PaperArr: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PaperTimerRng.randomize()
	PaperTypeRng.randomize()
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	for i in 5:
		var PaperType = PaperTypeRng.randi_range(0, 2)
		PaperType = 0 # test
		var PaperIns = PaperTypes[PaperType].instantiate()
		PaperArr.push_back(PaperIns)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var PaperArrItems: String
	for i in PaperArr.size():
		PaperArrItems += PaperArr[i].name + " "
	$PaperArr.text = PaperArrItems
	pass


func _on_timer_timeout() -> void:
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	var TmpPaper = PaperArr.pop_front()
	$PaperHolder.add_child(TmpPaper)
	var PaperType = PaperTypeRng.randi_range(0, 2)
	PaperType = 0 # test
	var PaperIns = PaperTypes[PaperType].instantiate()
	PaperArr.push_back(PaperIns)
