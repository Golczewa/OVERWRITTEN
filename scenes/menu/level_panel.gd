extends Control

var levels
var path:String
	
func _ready() -> void:
	hide()
	load_jason()
	$Button.pressed.connect(play)
	$Button2.pressed.connect(go_back)


func setup(num:int):
	var level_data=levels["levels"][num]
	if level_data["unlocked"]:
		show()
		$TextureRect.set_texture(load(level_data["image"]))
		$name.text="Level "+str(int(level_data["id"]))+" : "+level_data["name"]
		$rank.text="Rank: "+level_data["rank"]
		$score.text="Best score: "+str(int(level_data["score"]))
		path=level_data["path"]

func play():
		get_tree().current_scene.play_game(path)
		hide()

func go_back():
	hide()

func load_jason():
	var file = FileAccess.open("res://Jason/levels.json", FileAccess.READ)
	var content=file.get_as_text()
	file.close()
	var json=JSON.new()
	var error=json.parse(content)
	if error==OK:
		levels=json.data
	else:
		print("json parsing error in level_panel")
