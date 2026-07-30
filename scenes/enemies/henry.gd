extends CharacterBody2D

@export var test_max_health: int = 250
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var weapon: Area2D = $AnimatedSprite2D/Area2D
@onready var gun = $AnimatedSprite2D/AnimatedSprite2D2
@onready var legs = $AnimatedSprite2D/AnimatedSprite2D3
@onready var boss_bar = player.get_node("Camera2D/CanvasLayer/ProgressBar2")
var curr_health: int
var direction: Vector2 = Vector2.ZERO
var speed: int = 50
var rot_speed: int = 15
var floor_
var view_distance: int = 250
var player_sighted: bool = false
var in_knocback: bool = false
var dead = false
var can_attack = false
var range_: int = 400
var in_cutscene: bool = false
@export var walk_range: int = 200

signal died


func _ready() -> void:
	randomize()
	floor_ = get_parent().get_parent()
	weapon.body_entered.connect(player_in)
	weapon.body_exited.connect(player_out)
	curr_health = test_max_health
	legs.walk()
	_randomise_target()
	player_sighted = true


func take_damage(damage: int, knockback: int):
	if in_cutscene:
		return
	curr_health = curr_health - damage
	boss_bar.update(curr_health)
	if knockback != 0:
		legs.stop_walking()
		var org_speed = speed
		speed = knockback
		if direction == Vector2.ZERO:
			direction = -(
				Vector2($AnimatedSprite2D/RayCast2D.target_position - global_position).normalized()
			)
		else:
			direction = -direction
		in_knocback = true
		get_tree().create_timer(0.1).timeout.connect(end_knockback.bind(org_speed))
	_damage_effect()
	if (!player_sighted) and not player.invisible:
		player_sighted = true
	if curr_health <= 0 and not dead:
		_die()


func end_knockback(org_speed):
	speed = 0
	direction = -direction
	await get_tree().create_timer(1).timeout
	speed = org_speed
	in_knocback = false


func _die():
	dead = true
	floor_.enemies = floor_.enemies - 1
	emit_signal("died")
	$AnimatedSprite2D.play("dead")
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 1
	modulate = Color(0.25, 0.25, 0.25)
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D/RayCast2D.set_deferred("disabled", true)
	legs.stop_walking()
	legs.visible = not legs.visible
	gun.hide()
	boss_bar.boss_is_out()
	$AnimatedSprite2D/Area2D/AnimatedSprite2D.visible = not (
		$AnimatedSprite2D/Area2D/AnimatedSprite2D.visible
	)
	remove_from_group("enemies")


func _damage_effect():
	if curr_health > 0:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE


func _idle_moving():
	if nav_agent.is_navigation_finished():
		speed = 50
		rot_speed = 15
		direction = Vector2.ZERO
		_randomise_target()
		legs.walk()
		return
	var next_path = nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)


func _randomise_target():
	var x = randf_range(-walk_range, walk_range)
	var y = randf_range(-walk_range, walk_range)
	var target = global_position + Vector2(x, y)
	nav_agent.target_position = target


func _physics_process(_delta: float) -> void:
	if not in_cutscene:
		if !in_knocback:
			if player_sighted:
				chase()
			else:
				_idle_moving()
				var offset = Vector2.RIGHT.rotated(rotation) * 100
				var target_pos = global_position + offset
				gun.target = target_pos
			var target_angle = direction.angle()
			rotation = lerp_angle(rotation, target_angle, rot_speed * _delta)
		velocity = direction * speed
		if !player_sighted:
			player_sighted = can_see_player()
			if player_sighted:
				get_tree().call_group("enemies", "trigger")
		if can_attack:
			weapon.attack()
		move_and_slide()


func can_see_player():
	if player.invisible:
		return false
	var dist = global_position.distance_to(player.global_position)
	if dist > view_distance:
		return false
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.collision_mask = 3
	query.exclude = [self.get_rid()]
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider == player:
			return true
	return false


func chase():
	if curr_health <= test_max_health / 2:
		speed = 300
	else:
		speed = 200
	rot_speed = 20
	gun.target = player.global_position
	$AnimatedSprite2D.look_at(player.global_position)
	if not is_path_blocked():
		gun.attack()
	legs.run()
	nav_agent.target_position = player.global_position
	var next_path = nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)


func player_in(_body):
	if _body.is_in_group("player"):
		can_attack = true


func player_out(_body):
	if _body.is_in_group("player"):
		can_attack = false


func trigger():
	if not player.invisible:
		player_sighted = true


func is_path_blocked():
	$AnimatedSprite2D/AnimatedSprite2D2/RayCast2D.target_position = Vector2(range_, 0)
	if $AnimatedSprite2D/AnimatedSprite2D2/RayCast2D.is_colliding():
		var collider = $AnimatedSprite2D/AnimatedSprite2D2/RayCast2D.get_collider()
		if collider and collider.is_in_group("player"):
			return false
		else:
			return true
	return false


func toogle_cutscene() -> bool:
	gun.in_cutscene = !gun.in_cutscene
	in_cutscene = !in_cutscene
	return in_cutscene
