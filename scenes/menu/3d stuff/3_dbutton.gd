extends Area3D

@export var level: int = 0
var unlocked: bool
var level_section: String
var curr_color: Color
signal pressed_


func _ready() -> void:
	input_ray_pickable = true
	$MeshInstance3D.material_override = $MeshInstance3D.material_override.duplicate()
	level_section = "level_" + str(level)
	unlocked = ConfigManager.get_level_value(level_section, "unlocked", false)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_hover_exit)
	input_event.connect(_on_klik)
	set_button_colors()


func _on_klik(_camera, event, _pos, _normal, _idx) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
		and unlocked
	):
		emit_signal("pressed_")


func _on_hover() -> void:
	if unlocked:
		_change_color(curr_color.darkened(0.3))


func _on_hover_exit():
	if unlocked:
		_change_color(curr_color)


func _change_color(col: Color) -> Color:
	$MeshInstance3D.material_override.emission = col
	$MeshInstance3D.material_override.albedo_color = col
	return col


func set_button_colors() -> void:
	if unlocked:
		match ConfigManager.get_level_value(level_section, "rank", "-"):
			"S":
				curr_color = _change_color(Color.PURPLE)
			"A":
				curr_color = _change_color(Color.BLUE)
			"B":
				curr_color = _change_color(Color.GREEN)
			"C":
				curr_color = _change_color(Color.YELLOW)
			"D":
				curr_color = _change_color(Color.ORANGE)
			_:
				curr_color = _change_color(Color.WHITE)
	else:
		curr_color = _change_color(Color.GRAY.darkened(0.7))
