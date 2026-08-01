extends AnimatedSprite2D

@export_enum("default", "dead") var state: String = "default"
@export var color:Color=Color.YELLOW

func _ready() -> void:
	modulate=color
	$PointLight2D.color=color
	if state == "default":
		play("default")
	elif state == "dead":
		play("dead")
		$PointLight2D.hide()
