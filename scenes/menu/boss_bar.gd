extends ProgressBar
var boss_name:String ="Lorem ipsum"


func _ready() -> void:
	get_tree().current_scene.menu.connect(boss_is_out)
	get("theme_override_styles/fill").bg_color = Color.RED
	hide()

func boss_is_in(name_:String,max_:int):
	$Label.text=name_
	max_value=max_
	value=max_
	show()

func boss_is_out():
	hide()

func update(heath:int):
	value=heath
