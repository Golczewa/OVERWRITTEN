extends MenuWindow


func _ready() -> void:
	hide()
	panel.upper_panel.gui_input.connect(_on_panel_container_gui_input)
	panel.upper_bar.gui_input.connect(_on_panel_container_gui_input)
	panel.close_button.pressed.connect(begone)
#	get_tree().current_scene.game.connect(begone)
	open()