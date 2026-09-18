extends Control

var dragging = false
var drag_offset = Vector2()
var tween: Tween


func _ready() -> void:
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)
	modulate.a = 0


func boss_is_in(boss_name: String, hp: int, time = 1.5) -> void:
	AudioPlayer.play_game_sfx(AudioPlayer.hp_loading)
	$AspectRatioContainer.format_title(boss_name)
	$TextureProgressBar.max_value = hp
	tween = create_tween()
	$TextureProgressBar.value = 0
	tween.tween_property(self, "modulate:a", 1, 0.5)
	tween.tween_property($TextureProgressBar, "value", hp, time)
	await tween.finished


func boss_is_out():
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)


func update(heath: int):
	$TextureProgressBar.value = heath


func _on_panel_container_gui_input(event):
	if modulate.a != 0:
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


func stop_animation(hp: int, restart := true):
	if tween:
		tween.kill()
		if restart:
			modulate.a = 0
		else:
			modulate.a = 1
			$TextureProgressBar.value = hp
