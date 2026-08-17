extends Node2D


func _ready() -> void:
	markToRemove()


func markToRemove():
	await get_tree().create_timer(0.2).timeout
	queue_free()
