extends PlayerWeapon

var rocket_spred := -0.15


func attack():
	if can_attack and not is_hand_in_wall():
		can_attack = false
		var angle = rocket_spred
		for i in range(3):
			_spawn_bullet(angle, 0)
			angle += (-rocket_spred)
		play("cd")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)


func end_cd():
	play("default")
	can_attack = true
