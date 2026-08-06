extends StaticBody2D

@export_enum("scavenger","empty1","hunter","empty2","weapons1","weapons2") var skin:String="empty1"

const skin_dict:Dictionary={"scavenger"=0,"empty1"=1,"hunter"=2,"empty2"=3,"weapons1"=4,"weapons2"=5}

func _ready() -> void:
    $AnimatedSprite2D.frame=skin_dict[skin]    