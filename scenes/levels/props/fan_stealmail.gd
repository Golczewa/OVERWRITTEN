extends StaticBody2D

@export var rot_speed=-0.05

func _process(_delta: float) -> void:
	rotate(rot_speed)