extends Node2D

var PaperTimerRng = RandomNumberGenerator.new()
var PaperTypeRng = RandomNumberGenerator.new()

@onready var PaperTimer = get_node("PaperTimer")
@export var PaperTypes : Array[PackedScene]

var PaperArr: Array

var score: int = 0
var max_count: int = 3
var time: int = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PaperTimerRng.randomize()
	PaperTypeRng.randomize()
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	for i in max_count:
		PaperArr.push_back(create_paper())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var PaperArrItems: String
	# for paper in PaperArr:
	# 	PaperArrItems += paper.name + " "
	# $PaperArr.text = PaperArrItems
	$TimeProgressBar.value = $GameTimer.time_left

# create new paper node
func create_paper() -> Node2D:
	var PaperType = PaperTypeRng.randi_range(0, PaperTypes.size() - 1)
	var PaperIns = PaperTypes[PaperType].instantiate()
	PaperIns.target_position = $Scissors.global_position
	$PaperHolder.add_child(PaperIns)
	return PaperIns

func _on_timer_timeout() -> void:
	pass
	#PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	#var TmpPaper = PaperArr.pop_front()
	#PaperArr.push_back(create_paper())

func _on_click_3_way_system_to_long_tap(PaperArr: Array) -> void:
	get_tree().paused = true
	pass # Replace with function body.

func remove_paper(paper, score):
	PaperArr.erase(paper)
	if score != 0:
		update_score(score)
		#max_count += 1
	else:
		paper.queue_free()
	while max_count>len(PaperArr):
		PaperArr.push_back(create_paper())

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
	$music.stop()
	AudioServer.set_bus_effect_enabled(0, 0, false)
	AudioServer.set_bus_effect_enabled(0, 1, false)
	pass # Replace with function body.


func _on_start_button_button_up() -> void:
	score = 0
	max_count = 5
	$ScoreLabel.text = "0"
	$GameoverLabel.hide()
	$RetryButton.hide()
	get_tree().paused = false
	$Scissors.process_mode = Node.PROCESS_MODE_INHERIT
	$Scissors.position = $StartPosition.position
	$PaperTimer.start()
	PaperTimer.wait_time = PaperTimerRng.randf_range(0.7, 1.2)
	for i in 5:
		PaperArr.push_back(create_paper())
	$music.play()
	pass # Replace with function body.
