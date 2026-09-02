extends PlayerWeapon


func attack(_event):
	if can_attack:
		play("0")
		var hit_something:=false
		var bodies = mele_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies"):
				hit_something=true
				body.take_damage(dmg, knockback)
			elif body.is_in_group("window"):
				body.shatter(self)
			elif body.is_in_group("player"):
				continue
			else :
				hit_something=true
		can_attack = false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		if hit_something:
			AudioPlayer.play_game_sfx(AudioPlayer.slash)
		else :
			AudioPlayer.play_game_sfx(AudioPlayer.swosh)
		await animation_finished
		frame = 0


func _upper():
	if upper:
		$Sprite2D.play("upper")
	elif cloth:
		$Sprite2D.play("default_cloth")
