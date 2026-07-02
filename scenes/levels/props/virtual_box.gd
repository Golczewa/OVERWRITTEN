extends StaticBody2D

func begone():
	$CollisionShape2D.disabled=true
	var tween = create_tween().set_parallel(true)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0,0), 0.2)
	tween.tween_property($AnimatedSprite2D, "modulate:a",0, 0.2)
	tween.chain().tween_callback(queue_free)

func take_damage(_damage: int,_knockback:int):
	begone()