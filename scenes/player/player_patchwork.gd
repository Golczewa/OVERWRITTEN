extends PlayerWeapon


func attack(_event):
	if can_attack:
		can_attack = false
		if not is_hand_in_wall():
			for i in range(0, 3):
				if is_hand_in_wall():
					print("monday left me broken")
					break
				_spawn_bullet()
				AudioPlayer.play_game_sfx(AudioPlayer.patchwork_shot, 4)

				await get_tree().create_timer(0.2).timeout
		play("0")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)


func _upper():
	if upper:
		$Sprite2D.play("upper")
	elif cloth:
		$Sprite2D.play("default_cloth")
# extends AnimatedSprite2D
# var can_attack = true
# var bullet_test = preload("res://scenes/effects/bullet_test.tscn")
# var cooldown = 0.6
# var is_owned_by_player = true
# var skin
# var left_hand = false
# var weapon_rot: float

# func _ready() -> void:
# 	if left_hand:
# 		weapon_rot = 0.02
# 	else:
# 		weapon_rot = -0.02

# func _physics_process(_delta: float) -> void:
# 	look_at(get_global_mouse_position().rotated(0.02))

# func end_cd():
# 	can_attack = true

# func attack():
# 	if can_attack:
# 		can_attack = false
# 		if not is_hand_in_wall():
# 			for i in range(0, 3):
# 				_spawn_bullet()
# 				await get_tree().create_timer(0.2).timeout
# 		play("0")
# 		get_tree().create_timer(cooldown).timeout.connect(end_cd)

# func is_hand_in_wall():
# 	var bodies = $Area2D.get_overlapping_bodies()
# 	for body in bodies:
# 		if not body.is_in_group("enemies") and not body.is_in_group("player"):
# 			return true
# 	return false

# func _spawn_bullet():
# 	var bullet = bullet_test.instantiate()
# 	bullet.perce = 0
# 	bullet.dmg = 15
# 	var random_angle = deg_to_rad(randf_range(-2, 2))
# 	bullet.shot_by_player = true
# 	var spawn_pos = $Marker2D2.global_position
# 	var spawn_dir = ($Marker2D.global_position - spawn_pos).normalized().rotated(random_angle)
# 	bullet.direction = spawn_dir
# 	bullet.global_position = spawn_pos
# 	get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
# 	bullet.look_at($Marker2D.global_position)
