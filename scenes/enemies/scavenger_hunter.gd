extends Enemy

@onready var bullet_pack: PackedScene = preload("res://scenes/effects/bullet_test.tscn")
var standing_room: int = 50
var damage = 17
var pierce = 0
var closeup = 250


func _engage() -> void:
	var stand := false
	curr_speed = chase_speed
	if not in_cooldown and can_see_player() and not is_spawning:
		_attack()
	weapon.look_at(player.global_position.rotated(weapon_offset))
	var player_distance: float = (player.global_position - global_position).length()
	if player_distance < closeup and can_see_player():
		legs.walk()
		nav_agent.target_position = get_opposite()
		if nav_agent.is_target_reachable():
			legs.walk()
		else:
			direction = Vector2.ZERO
			stand = true
			legs.stop()
	elif (
		closeup < player_distance and player_distance < closeup + standing_room and can_see_player()
	):
		direction = Vector2.ZERO
		stand = true
		legs.stop()
	else:
		legs.walk()
		nav_agent.target_position = player.global_position
	var next_pos = nav_agent.get_next_path_position()
	body.look_at(player.global_position)
	legs.toogle_fallow(next_pos)
	if not stand:
		direction = global_position.direction_to(next_pos)


func _attack() -> void:
	in_cooldown = true
	var spawn_marker: Marker2D = $AnimatedSprite2D/AnimatedSprite2D/Marker2D
	var dir_marker: Marker2D = $AnimatedSprite2D/AnimatedSprite2D/Marker2D2
	for i in range(0, 3):
		if dead or in_knocback:
			break
		AudioPlayer.play_game_sfx(AudioPlayer.patchwork_shot, 4)
		var bullet = bullet_pack.instantiate()
		bullet.direction = (dir_marker.global_position - spawn_marker.global_position).normalized()
		curr_floor.add_child(bullet)
		bullet.global_position = spawn_marker.global_position
		bullet.look_at(dir_marker.global_position)
		await get_tree().create_timer(0.2).timeout
	get_tree().create_timer(cooldown_time).timeout.connect(end_cooldown)
