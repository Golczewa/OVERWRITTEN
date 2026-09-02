extends PlayerWeapon

@onready var sparks_pack: PackedScene = preload("res://scenes/effects/chainsaw_spark.tscn")

var event: String
var chainsaw_sound: AudioStreamPlayer


func _ready() -> void:
	play("default")
	if left_hand:
		weapon_rot = rot_offset
	else:
		weapon_rot = -rot_offset
	_upper()


func attack(_event: String) -> void:
	play("attack")
	event = _event
	if chainsaw_sound == null:
		chainsaw_sound = AudioPlayer.play_game_sfx_loop(AudioPlayer.chainsaw_running)
	while Input.is_action_pressed(_event):
		check_for_enemies()
		await get_tree().create_timer(cooldown).timeout
	if chainsaw_sound:
		chainsaw_sound.stop()
		chainsaw_sound = null
	play("default")


func check_for_enemies():
	var bodies = mele_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.take_damage(dmg, knockback)
		elif body.is_in_group("window"):
			body.shatter(self)


func spawn_spark(node: Node2D) -> void:
	var sparks: GPUParticles2D = sparks_pack.instantiate()
	node.add_child(sparks)
	sparks.global_position = node.global_position


func _upper():
	if upper:
		$Sprite2D.play("upper")
	elif cloth:
		$Sprite2D.play("default_cloth")
