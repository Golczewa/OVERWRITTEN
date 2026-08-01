extends AnimatedSprite2D

@export_enum("default", "dead") var state: String = "default"
@export var color:Color=Color.YELLOW

func _ready() -> void:
	$PointLight2D.color=color
	if state == "default":
		modulate=color
		play("default")
	elif state == "dead":
		play("dead")
		$PointLight2D.hide()
