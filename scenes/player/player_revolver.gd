extends PlayerWeapon


func attack(_event):
	if is_hand_in_wall():
		return
	var enemy_in_hand: Node2D = is_hand_in_enemy()
	if enemy_in_hand:
		enemy_in_hand.take_damage(dmg, 0)
		AudioPlayer.play_game_sfx(AudioPlayer.revolver_shot)
		return
	if can_attack:
		AudioPlayer.play_game_sfx(AudioPlayer.revolver_shot)
		_spawn_bullet(0, 4, 1)
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		can_attack = false


func _upper():
	if upper:
		$Sprite2D.play("upper")
	elif cloth:
		$Sprite2D.play("default_cloth")
# extends AnimatedSprite2D
# var can_attack = true
# var bullet_test = preload("res://scenes/effects/bullet_test.tscn")
# var cooldown = 0.3
# var is_owned_by_player = true
# var skin
# var left_hand = false
# var weapon_rot: float

# func _physics_process(_delta: float) -> void:
# 	look_at(get_global_mouse_position())

# func _ready() -> void:
# 	if left_hand:
# 		weapon_rot = 0.02
# 	else:
# 		weapon_rot = -0.02

# func end_cd():
# 	can_attack = true

# func attack():
# 	if can_attack:
# 		if not is_hand_in_wall():
# 			var random_angle
# 			var bullet = bullet_test.instantiate()
# 			random_angle = deg_to_rad(randf_range(-4, 4))
# 			bullet.shot_by_player = true
# 			bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
# 			bullet.direction = bullet.direction.rotated(random_angle)
# 			bullet.global_position = $Marker2D2.global_position
# 			get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
# 			bullet.look_at($Marker2D.global_position)
# 		can_attack = false
# 		play("0")
# 		get_tree().create_timer(cooldown).timeout.connect(end_cd)

# func is_hand_in_wall():
# 	var bodies = $Area2D.get_overlapping_bodies()
# 	for body in bodies:
# 		if not body.is_in_group("enemies") and not body.is_in_group("player"):
# 			return true
# 	return false
