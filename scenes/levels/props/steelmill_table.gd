extends StaticBody2D

@export_enum("scavenger","empty1","hunter","empty2") var skin:String="empty1"

const skin_dict:Dictionary={"scavenger"=0,"empty1"=1,"hunter"=2,"empty2"=3}

func _ready() -> void:
    $AnimatedSprite2D.play("default")
    $AnimatedSprite2D.stop()
    $AnimatedSprite2D.frame=skin_dict[skin]    