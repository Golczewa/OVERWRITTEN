extends Control

var levels:ConfigFile
var path:String
	
func _ready() -> void:
	hide()
	load_config()
	$Button.pressed.connect(play)
	$Button2.pressed.connect(go_back)
	$Control.update_all_sig.connect(update_all)
	$Control2.update_all_sig.connect(update_all)



func setup(num:int):
	var section_name="level_"+str(num)
	if levels.get_value(section_name,"unlocked")==true:
		show()
		$TextureRect.set_texture(load(levels.get_value(section_name,"image")))
		$name.text="Level "+str(num)+" : "+levels.get_value(section_name,"name")
		$rank.text="Rank: "+levels.get_value(section_name,"rank")
		$score.text="Best score: "+str(levels.get_value(section_name,"score"))
		path=levels.get_value(section_name,"path")

func play():
		get_tree().current_scene.play_game(path)
		hide()

func go_back():
	hide()

func load_jason():
	var file = FileAccess.open("res://config/levels.json", FileAccess.READ)
	var content=file.get_as_text()
	file.close()
	var json=JSON.new()
	var error=json.parse(content)
	if error==OK:
		levels=json.data
	else:
		print("json parsing error in level_panel")

func load_config():
	var config=ConfigFile.new()
	var err = config.load("res://config/levels.cfg")
	if err!=OK:
		print("confing loading error")
		return
	levels=config

func update_all():
	$Control.update()
	$Control2.update()