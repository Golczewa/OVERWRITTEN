extends StaticBody2D

@export var skin:int=0

func _ready() -> void:
	if skin>5:
		skin=5
	$AnimatedSprite2D.frame=skin

