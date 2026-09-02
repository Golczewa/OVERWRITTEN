extends PlayerWeapon


func attack(_event):
	if can_attack:
		var hit_something: bool = false
		can_attack = false
		var bodies = mele_area.get_overlapping_bodies()
		if upper:
			play("upper")
		elif cloth:
			play("cloth")
		else:
			play("default")
		for body in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(dmg, knockback)
				hit_something = true
			elif body.is_in_group("window"):
				body.shatter(self)
			elif body.is_in_group("player"):
				continue
			else:
				hit_something = true
		if hit_something:
			AudioPlayer.play_game_sfx(AudioPlayer.punch)
		else:
			AudioPlayer.play_game_sfx(AudioPlayer.swosh)
		await animation_finished
		frame = 0
		get_tree().create_timer(cooldown).timeout.connect(end_cd)


func _upper():
	if upper:
		animation = "upper"
		frame = 0
	elif cloth:
		animation = "cloth"
		frame = 0

# extends Area2D
# var damage = 10
# var knockback = 200
# var cooldown = 0.25
# var can_attack = true
# var left_hand = false
# var weapon_rot: float

# func _ready() -> void:
# 	$AnimatedSprite2D.frame = 0
# 	if left_hand:
# 		weapon_rot = 0.02
# 	else:
# 		weapon_rot = -0.02

# func attack():
# 	if can_attack:
# 		can_attack = false
# 		var bodies = get_overlapping_bodies()
# 		$AnimatedSprite2D.play("default")
# 		for body in bodies:
# 			if body.is_in_group("enemies"):
# 				body.take_damage(damage, knockback)
# 		await $AnimatedSprite2D.animation_finished
# 		$AnimatedSprite2D.frame = 0
# 		get_tree().create_timer(cooldown).timeout.connect(end_cd)

# func _physics_process(_delta: float) -> void:
# 	look_at(get_global_mouse_position())

# func end_cd():
# 	can_attack = true
