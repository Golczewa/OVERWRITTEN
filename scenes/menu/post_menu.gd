extends Control

var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player=get_tree().get_first_node_in_group("player")
	$Control.update_all_sig.connect(update_all)
	$Control2.update_all_sig.connect(update_all)


func update_all():
	$Control.update()
	$Control2.update()
	player.equip_weapons()
