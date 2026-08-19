extends MenuWindow

var player


func _ready() -> void:
	hide()
	panel.gui_input.connect(
		_on_panel_container_gui_input
	)
	panel.gui_input.connect(
		_on_panel_container_gui_input
	)
	panel.close_button.pressed.connect(begone)
	player = get_tree().get_first_node_in_group("player")
	$Control.update_all_sig.connect(update_all)
	$Control2.update_all_sig.connect(update_all)
	open()

func update_all():
	$Control.update()
	$Control2.update()
	player.equip_weapons()

func _exit_tree()-> void:
	begone()