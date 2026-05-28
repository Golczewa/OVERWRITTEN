extends StaticBody2D

@export var skin:int=0

func _ready() -> void:
	if skin<6:
		skin=5
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.frame=skin

