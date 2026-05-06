extends AnimatedSprite2D
var can_attack = true
var bullet_test = preload("res://scenes/effects/bullet_test.tscn")
var cooldown=0.6
var is_owned_by_player=true
var skin



func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func end_cd():
	can_attack=true

func attack():
	if can_attack:
		can_attack=false
		if not is_hand_in_wall():
			for i in range(0,3):
				var random_angle
				var bullet = bullet_test.instantiate()
				bullet.perce=0
				bullet.dmg=15
				random_angle = deg_to_rad(randf_range(-2, 2))
				bullet.shot_by_player=true
				bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
				bullet.direction=bullet.direction.rotated(random_angle)
				get_tree().current_scene.add_child(bullet) 
				bullet.global_position=$Marker2D2.global_position
				bullet.look_at($Marker2D.global_position)
				await  get_tree().create_timer(0.2).timeout
		play("0")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)

func is_hand_in_wall():
	var bodies=$Area2D.get_overlapping_bodies()
	for body in bodies:
			if not body.is_in_group("enemies") and not body.is_in_group("player"):
				return true
	return false
