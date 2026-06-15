extends Area3D

@export var level:int=0
var unlocked:bool
var level_section:String
var levels:ConfigFile
signal pressed_

func _ready()->void:
	input_ray_pickable = true
	$MeshInstance3D.material_override = $MeshInstance3D.material_override.duplicate()
	levels=ConfigManager.levels
	level_section="level_"+str(level)
	unlocked=levels.get_value(level_section,"unlocked",false)
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_hover_exit)
	input_event.connect(_on_klik)
	if not unlocked:
		change_color(Color.GRAY)

func _on_klik(_camera, event, _pos, _normal, _idx)->void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and unlocked:
		emit_signal("pressed_")

func _on_hover()->void:
	if unlocked:
		change_color(Color.ORANGE)

func _on_hover_exit():
	if unlocked:
		change_color(Color.YELLOW)

func change_color(col:Color)->void:
	$MeshInstance3D.material_override.emission=col
	$MeshInstance3D.material_override.albedo_color=col