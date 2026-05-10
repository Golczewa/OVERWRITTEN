extends Node2D
@onready var player=$CharacterBody2D
var curr_scene
var gameScore={"time":0,
"deaths":0,
"hused":0,
"score":0,
"rank":"-"
}


func _ready() -> void:
	$"CanvasLayer/skill issue".restart.connect(restart)
	$CanvasLayer/pause/Button3.pressed.connect(restart)
	$Timer.timeout.connect(add_time)

func load_level(path:String):
	if not curr_scene ==null:
		curr_scene.queue_free()
	var level_pre=load(path)
	var level=level_pre.instantiate()
	level.player=player
	curr_scene=level
	add_child(level)
	resetScore()
	$Timer.start(1)

func restart():
	curr_scene.restart_floor()
	$"CanvasLayer/skill issue".hide()
	$CanvasLayer/pause.hide()
 	
func showGameUI():
	show()
	$CanvasLayer.show()
	$CanvasLayer/pause.hide()
	$"CanvasLayer/skill issue".hide()
	$CharacterBody2D/Camera2D/CanvasLayer.show()

func hideGameUI():
	hide()
	$CanvasLayer.hide()
	$CharacterBody2D/Camera2D/CanvasLayer.hide()

func resetScore():
	gameScore["time"]=0
	gameScore["deaths"]=0
	gameScore["hused"]=0
	gameScore["score"]=0
	gameScore["rank"]="-"
	
func add_time():
	gameScore["time"]=gameScore["time"]+1
	$Timer.start(1)

func timer_stop():
	$Timer.stop()
