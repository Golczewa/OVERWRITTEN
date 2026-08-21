extends MenuWindow

var keep_tween: bool = true
var is_revealed: bool = false
var rainbow_tween: Tween
signal reveal


func _ready():
	hide()
	panel.upper_panel.gui_input.connect(_on_panel_container_gui_input)
	panel.upper_bar.gui_input.connect(_on_panel_container_gui_input)
	panel.close_button.pressed.connect(begone)
	$Button.pressed.connect(begone)


func unlock_weapon(num: int, reval_time: float = 1.5):
	open()
	rainbow()
	$TextureRect.texture = load(
		ConfigManager.weapons.get_value(str(num), "image", "res://icon.svg")
	)
	$Label.text = ConfigManager.weapons.get_value(str(num), "name", "???")
	await reveal
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property($TextureRect, "modulate", Color.WHITE, reval_time)
	tween.tween_property($Label, "modulate", Color.WHITE, reval_time)
	await tween.finished
	$Button.show()
	is_revealed = true


func set_color(c: Color):
	var colors = $shader.material.get_shader_parameter("stripe_colors")
	colors[1] = c
	$shader.material.set_shader_parameter("stripe_colors", colors)


func rainbow(time: float = 1, pale: float = 0.8):
	var base_colors: Array[Color] = [
		Color.RED,
		Color.ORANGE,
		Color.YELLOW,
		Color.GREEN,
		Color.CYAN,
		Color.BLUE,
		Color.PURPLE,
	]
	var colors: Array[Color] = []
	for c in base_colors:
		colors.append(c.lerp(Color.WHITE, pale))

	while keep_tween:
		for i in colors.size():
			var from_color = colors[i]
			var to_color = colors[(i + 1) % colors.size()]
			rainbow_tween = create_tween()
			rainbow_tween.tween_method(set_color, from_color, to_color, time)
			await rainbow_tween.finished
			if not keep_tween:
				break


func begone():
	if not is_revealed:
		return
	keep_tween = false
	rainbow_tween.stop()
	for child in get_children():
		if child != panel:
			child.hide()
	await panel.close_animation()
	queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not is_revealed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				reveal.emit()


func open():
	for child in get_children():
		child.hide()
	show()
	await panel.open_animation()
	for child in get_children():
		if child != $Button:
			child.show()
