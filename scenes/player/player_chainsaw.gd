extends PlayerWeapon

@onready var sparks_pack:PackedScene=preload("res://scenes/effects/chainsaw_spark.tscn")

func _ready() -> void:
	play("default")
	if left_hand:
		weapon_rot = rot_offset
	else:
		weapon_rot = -rot_offset


func attack(_event: String) -> void:
	play("attack")
	while Input.is_action_pressed(_event):
		check_for_enemies()
		await get_tree().create_timer(cooldown).timeout
	play("default")


func check_for_enemies():
	var bodies = mele_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var sparks:GPUParticles2D=sparks_pack.instantiate()
			sparks.global_position=body.global_position
			body.add_child(sparks)
			body.take_damage(dmg, knockback)
		elif body.is_in_group("window"):
			body.shatter(self)
