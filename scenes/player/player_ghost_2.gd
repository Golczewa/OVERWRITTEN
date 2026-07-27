extends AnimatedSprite2D

@export var lengh: int = 10

func _ready() -> void:
	markToRemove()

## Removes this ghost sprite after a short delay.
func markToRemove() -> void:
	await get_tree().create_timer(0.2).timeout
	queue_free()
