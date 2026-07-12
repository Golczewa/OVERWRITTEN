extends StaticBody2D

@export var rot_speed=-0.2

func _physics_process(_delta: float) -> void:
	$Sprite2D/Sprite2D.rotate(rot_speed)
