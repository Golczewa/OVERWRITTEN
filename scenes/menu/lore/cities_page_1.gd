extends MenuWindow

func begone():
	for child in get_children():
		if child != panel:
			child.hide()
	await panel.close_animation()
	hide()
	hiding.emit()
	get_tree().get_first_node_in_group("player").in_menu=false