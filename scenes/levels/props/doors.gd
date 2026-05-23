extends Area2D



func _ready() -> void:
	body_entered.connect(on_body_enterd)
	body_exited.connect(on_body_exited)
	$StaticBody2D/AnimatedSprite2D.frame=0
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)

func on_body_enterd(body):
	if body.is_in_group("player") or body.is_in_group("enemies"):
		if bodies_in() > 0 and bodies_in()<2:
			$StaticBody2D/AnimatedSprite2D.play("open")
			$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	
func on_body_exited(body):
	if body.is_in_group("player") or body.is_in_group("enemies"):
		if bodies_in() < 1:
			$StaticBody2D/AnimatedSprite2D.play_backwards("open")
			$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)

func bodies_in() -> int:
	var bodies=get_overlapping_bodies()
	var bodies_count=0
	for body in bodies:
		if body.is_in_group("player") or body.is_in_group("enemies"):
			bodies_count=bodies_count+1
	return bodies_count
