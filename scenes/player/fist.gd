extends Area2D
var damage=10
var knockback=200
var cooldown=0.25
var can_attack=true

func _ready() -> void:
	$AnimatedSprite2D.frame=0

func attack():
	if can_attack:
		can_attack=false
		var bodies=get_overlapping_bodies()
		$AnimatedSprite2D.play("default")
		for body in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(damage,knockback)
		await  $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.frame=0
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

func end_cd():
	can_attack=true
