extends StaticBody2D

@export_enum("upper", "lower") var skin: String = "upper"


func _ready() -> void:
	if skin == "upper":
		$AnimatedSprite2D.frame = 0
	else:
		$AnimatedSprite2D.frame = 1
		$PointLight2D.enabled = false
