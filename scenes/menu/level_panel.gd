extends Control

var path:String
	
func _ready() -> void:
	hide()
	$Button.pressed.connect(play)
	$Button2.pressed.connect(go_back)
	$Control.update_all_sig.connect(update_all)
	$Control2.update_all_sig.connect(update_all)



func setup(num:int):
	var section_name="level_"+str(num)
	if ConfigManager.levels.get_value(section_name, "unlocked") == true:
		show()
		$TextureRect.set_texture(load(ConfigManager.levels.get_value(section_name, "image")))
		$name.text = "Level " + str(num) + " : " + ConfigManager.levels.get_value(section_name, "name")
		$rank.text = "Rank: " + ConfigManager.levels.get_value(section_name, "rank")
		$score.text = "Best score: " + str(ConfigManager.levels.get_value(section_name, "score"))
		path = ConfigManager.levels.get_value(section_name, "path")
		update_all()

func play():
		get_tree().current_scene.play_game(path)
		hide()

func go_back():
	hide()

func update_all():
	$Control.update()
	$Control2.update()
