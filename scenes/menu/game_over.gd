extends Control

var dragging = false
var drag_offset = Vector2()

@onready var player = get_tree().get_first_node_in_group("player")
signal restart


func _ready() -> void:
	$VBoxContainer/Button.pressed.connect(when_pressed)
	hide()
	player.player_died.connect(on_player_died)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)


func on_player_died():
	open()
	get_tree().paused = true


func when_pressed():
	if get_tree().paused:
		get_tree().paused = false
		AudioPlayer.death_unpause()
		emit_signal("restart")


func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position

	if event is InputEventMouseMotion and dragging:
		var target_position = get_global_mouse_position() - drag_offset
		var viewport_size = get_viewport_rect().size
		var window_size = size
		target_position.x = clamp(target_position.x, 0, viewport_size.x - window_size.x)
		target_position.y = clamp(target_position.y, 0, viewport_size.y - window_size.y)
		global_position = target_position


func open():
	show()
	for child in get_children():
		child.hide()
	await $AspectRatioContainer.open_animation()
	for child in get_children():
		child.show()
	if randi_range(0, 10) == 0:
		$Label.text = "Skill Issue"
	else:
		$Label.text = "Game Over"
