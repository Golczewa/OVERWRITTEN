extends StaticBody2D

var floor_
var dead = false


func _ready() -> void:
	floor_ = get_parent().get_parent()
	floor_.enemies = floor_.enemies + 1


func begone():
	floor_.enemies = floor_.enemies - 1
	$CollisionShape2D.set_deferred("disabled", true)
	$PointLight2D.hide()
	var tween = create_tween().set_parallel(true)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0, 0), 0.2)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.2)
	dead = true


func take_damage(_damage: int, _knockback: int):
	if not dead:
		begone()
