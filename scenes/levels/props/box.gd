extends StaticBody2D

@export_enum("closed", "open_small_1", "open_empty", "open_small_2", "open_alot_1", "open_alot_2")
var skin: String = "closed"

const skin_num: Dictionary = {
	"closed": 0,
	"open_small_1": 1,
	"open_empty": 2,
	"open_small_2": 3,
	"open_alot_1": 4,
	"open_alot_2": 5,
}


func _ready() -> void:
	$AnimatedSprite2D.frame = skin_num[skin]
