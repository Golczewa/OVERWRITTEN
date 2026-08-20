extends PlayerWeapon


func attack(_event):
	if can_attack:
		play("0")
		var bodies = mele_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(dmg, knockback)
			elif body.is_in_group("window"):
				body.shatter(self)
		can_attack = false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		await animation_finished
		frame = 0


func _upper():
	if upper:
		$Sprite2D.play("upper")
