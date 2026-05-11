extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.frame=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func attack():
	$AnimatedSprite2D.play("default")
	await  $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.frame=0
