extends Control

@onready var player = get_tree().get_first_node_in_group("player")
signal restart
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(when_pressed)
	hide()
	player.player_died.connect(on_player_died)

func on_player_died():
	show()
	get_tree().paused=true
	

func when_pressed():
	if get_tree().paused:
		get_tree().paused=false
		emit_signal("restart")
