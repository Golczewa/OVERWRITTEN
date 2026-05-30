extends AnimatedSprite2D

@export_enum("default", "dead") var state: String = "default"

func _ready() -> void:
	if state == "default":
		play("default")
	elif state == "dead":
		play("dead")
		$PointLight2D.hide()
