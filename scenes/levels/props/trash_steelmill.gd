extends AnimatedSprite2D

@export_enum("hearth","plate1","screw1","screw2","eye","hand1","cable1","leg","weel","core","hand","cable","plate2","random","generator") var skin:String="random"

var skin_num: Dictionary = {
	"hearth": 0,
	"plate1": 1,
	"screw1": 2,
	"screw2": 3,
	"eye": 4,
	"hand1": 5,
	"cable1": 6,
	"leg": 7,
	"weel": 8, 
	"core": 9,
	"hand": 10,
	"cable": 11,
	"plate2": 12
}

var skin_int:int=0

func _ready() -> void:
	if skin=="random":
		set_skin(randi() % skin_num.size())
	elif skin=="generator":
		set_skin(skin_int)
	else:
		set_skin(skin_num[skin])

func set_skin(num:int)->void:
	play("default")
	stop()
	frame=num