extends Node2D
@onready var player=$CharacterBody2D
var curr_scene

func _ready() -> void:
	$"CanvasLayer/skill issue".restart.connect(restart)
	$CanvasLayer/pause/Button3.pressed.connect(restart)

func load_level(path:String):
	if not curr_scene ==null:
		curr_scene.queue_free()
	var level_pre=load(path)
	var level=level_pre.instantiate()
	level.player=player
	curr_scene=level
	add_child(level)

func restart():
	curr_scene.restart_floor()
	#player.player_health=100
	#player.hp_update()
	$"CanvasLayer/skill issue".hide()
	$CanvasLayer/pause.hide()
