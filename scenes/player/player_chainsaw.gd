extends PlayerWeapon

func _ready() -> void:
	play("default")
	if left_hand:
		weapon_rot = rot_offset
	else:
		weapon_rot = -rot_offset

func attack():
	pass

func check_for_enemies():
	var bodies=mele_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.take_damage(dmg,knockback)
		elif body.is_in_group("window"):
			body.shatter(self)

