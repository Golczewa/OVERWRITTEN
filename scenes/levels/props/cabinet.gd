extends StaticBody2D

@export_enum("closed","half-open","open") var skin:String="closed"

const skin_num:Dictionary={
	"closed":0,
	"half-open":1,
	"open":2
}

func _ready() -> void:
	$AnimatedSprite2D.frame=skin_num[skin]
