extends StaticBody2D

@export_enum("on", "off") var state: String = "off"


func _ready() -> void:
	if state == "off":
		$PointLight2D.hide()
	else:
		$PointLight2D2.hide()
	$AnimatedSprite2D.play(state)
