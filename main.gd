extends Node2D

var PaperTimerRng = RandomNumberGenerator.new()
var PaperTypeRng = RandomNumberGenerator.new()

@onready var PaperTimer = get_node("PaperTimer")
@export var PaperTypes : Array[PackedScene]
var PaperArr: Array
var score: int = 0
var time: int = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PaperTimerRng.randomize()
	PaperTypeRng.randomize()
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	for i in 5:
		var PaperType = PaperTypeRng.randi_range(0, PaperTypes.size() - 1)
		var PaperIns = PaperTypes[PaperType].instantiate()
		PaperArr.push_back(PaperIns)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var PaperArrItems: String
	for i in PaperArr.size():
		PaperArrItems += PaperArr[i].name + " "
	$PaperArr.text = PaperArrItems
	$TimeProgressBar.value = $GameTimer.time_left
	pass

func _on_timer_timeout() -> void:
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	var TmpPaper = PaperArr.pop_front()
	$PaperHolder.add_child(TmpPaper)
	var PaperType = PaperTypeRng.randi_range(0, PaperTypes.size() - 1)
	var PaperIns = PaperTypes[PaperType].instantiate()
	PaperArr.push_back(PaperIns)

func _on_click_3_way_system_to_long_tap() -> void:
	get_tree().paused = true
	pass # Replace with function body.

func update_score(value):
	score = max(0, score + value)
	$ScoreLabel.text = str(score)


func _on_game_timer_timeout() -> void:
	# game over
	$GameoverLabel.show()
	$RetryButton.show()
	get_tree().paused = true
	var papers = $PaperHolder.get_children()
	$Scissors.process_mode = Node.PROCESS_MODE_PAUSABLE
	$Scissors.target = null
	for paper in papers:
		paper.queue_free()
	PaperArr.resize(0)
	pass # Replace with function body.


func _on_start_button_button_up() -> void:
	score = 0
	$ScoreLabel.text = "0"
	$GameoverLabel.hide()
	$RetryButton.hide()
	get_tree().paused = false
	$Scissors.process_mode = Node.PROCESS_MODE_INHERIT
	$Scissors.position = $StartPosition.position
	$PaperTimer.start()
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	for i in 5:
		var PaperType = PaperTypeRng.randi_range(0, PaperTypes.size() - 1)
		var PaperIns = PaperTypes[PaperType].instantiate()
		PaperArr.push_back(PaperIns)
	pass # Replace with function body.
