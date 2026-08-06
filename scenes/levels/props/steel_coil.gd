extends StaticBody2D

@export_enum("clear", "packed") var skin = "clear"


func _ready() -> void:
	if skin == "clear":
		$AnimatedSprite2D.frame = 0
	else:
		$AnimatedSprite2D.frame = 1
