extends AnimatedSprite2D


func _ready() -> void:
	steal_his_look()

func steal_his_look():
	var player = get_tree().get_first_node_in_group("player")
	var player_torso=player.get_node("AnimatedSprite2D")
	sprite_frames=player_torso
	frame=player_torso.frame
	
