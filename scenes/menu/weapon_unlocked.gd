extends MenuWindow

var keep_tween:bool = true
var rainbow_tween:Tween

func _ready():
	hide()
	panel.upper_panel.gui_input.connect(_on_panel_container_gui_input)
	panel.upper_bar.gui_input.connect(_on_panel_container_gui_input)
	panel.close_button.pressed.connect(begone)
	open()
	rainbow()

func set_color(c: Color):
	var colors = $shader.material.get_shader_parameter("stripe_colors")
	colors[1] = c
	$shader.material.set_shader_parameter("stripe_colors", colors)

func rainbow(time: float = 5, pale: float = 0.7):
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
	keep_tween=false
	rainbow_tween.stop()
	for child in get_children():
		if child != panel:
			child.hide()
	await panel.close_animation()
	queue_free()