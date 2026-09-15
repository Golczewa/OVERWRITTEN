extends Enemy

var bullet_pack = preload("res://scenes/effects/rocket.tscn")
var standing_room: int = 100
var damage = 35
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
	var spawn_marker: Marker2D = $Sprite2D/AnimatedSprite2D/Marker2D
	var dir_marker: Marker2D = $Sprite2D/AnimatedSprite2D/Marker2D2
	AudioPlayer.play_game_sfx(AudioPlayer.lauch)
	can_attack = false
	var rot = -0.35
	for i in range(3):
		var bullet = bullet_pack.instantiate()
		bullet.perce = 0
		bullet.dmg = 25
		bullet.shot_by_player = false
		bullet.direction = (-spawn_marker.global_position + dir_marker.global_position).normalized()
		bullet.direction = bullet.direction.rotated(rot)
		get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
		bullet.global_position = spawn_marker.global_position
		bullet.look_at(dir_marker.global_position)
		bullet.rotate(rot)
		rot += 0.35
	$Sprite2D/AnimatedSprite2D.play("cd")
	get_tree().create_timer(cooldown_time).timeout.connect(end_cooldown)


func end_cooldown():
	in_cooldown = false
	$Sprite2D/AnimatedSprite2D.play("default")
