extends Area2D


func _ready() -> void:
	body_entered.connect(on_body_enterd)
	body_exited.connect(on_body_exited)
	$StaticBody2D/AnimatedSprite2D.frame=0
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)


func on_body_enterd(body):
	if not body==$StaticBody2D:
		$StaticBody2D/AnimatedSprite2D.play("open")
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	

func on_body_exited(body):
	if not body==$StaticBody2D:
		$StaticBody2D/AnimatedSprite2D.play_backwards("open")
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
