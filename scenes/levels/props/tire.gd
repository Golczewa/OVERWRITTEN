extends Node2D

@export_enum("knocked", "standing") var state = "knocked"
var stand: bool


func _ready() -> void:
	if state == "standing":
		$StaticBody2D/AnimatedSprite2D.play("default")
		$StaticBody2D/AnimatedSprite2D.frame = 1
		stand = true
		$StaticBody2D/CollisionShape2D.disabled = false
		$StaticBody2D/CollisionShape2D2.disabled = true

	else:
		stand = false
		$StaticBody2D/CollisionShape2D.disabled = true
		$StaticBody2D/CollisionShape2D2.disabled = false
