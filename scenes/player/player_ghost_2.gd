extends AnimatedSprite2D

@export var lengh = 10


func _ready() -> void:
	markToRemove()


func markToRemove():
	await get_tree().create_timer(0.2).timeout
	queue_free()
