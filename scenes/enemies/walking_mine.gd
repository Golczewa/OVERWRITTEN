extends Enemy

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	curr_health = max_heatlh
	curr_floor.enemies += 1
	legs.walk()
	if spawn_dest != Vector2.ZERO and is_spawning:
		in_cooldown = true
		await big_entrance(spawn_dest)
		trigger()
		get_tree().create_timer(cooldown_time).timeout.connect(end_cooldown)
	trigger()


func _engage() -> void:
	curr_speed=chase_speed
	nav_agent.target_position=player.global_position
	var next_path=nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path).normalized()
	legs.toogle_fallow(next_path)


