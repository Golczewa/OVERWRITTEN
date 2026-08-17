extends CharacterBody2D

@onready var rocket_pack: PackedScene = preload("res://scenes/effects/rocket.tscn")
@onready var hrocket_pack: PackedScene = preload("res://scenes/effects/hoaming_rocket.tscn")
@onready var danger_zone_pack: PackedScene = preload("res://scenes/effects/death_from_above.tscn")
@onready var ghost_pack: PackedScene = preload("res://scenes/enemies/scavenger_leader_ghost.tscn")

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var shield: StaticBody2D = $body/shield
@onready var legs: AnimatedSprite2D = $body/legs
@onready var sword: AnimatedSprite2D = $body/sword
@onready var laucher: AnimatedSprite2D = $body/laucher
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var rocket_spawn: Marker2D = $body/laucher/Marker2D2
@onready var rocket_directory: Marker2D = $body/laucher/Marker2D

var max_health := 500
var health: int = max_health
var speed := 30
var charge_speed := 900
var is_charging := false
var in_cutscene := false
var rot_speed := 0.5
var shield_rot_speed := 5
var dead := false
var direction := Vector2.ZERO
var in_cooldown := false
var attack_cooldonwn := 3
var curr_floor: Floor


func _ready() -> void:
	curr_floor = get_parent().get_parent()
	sword.play("default")
	add_collision_exception_with(shield)


func _physics_process(_delta: float) -> void:
	if in_cutscene or !player:
		return
	if is_charging:
		move_and_slide()
		if get_slide_collision_count() > 0:
			is_charging = false
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				var collider = collision.get_collider()
				if collider is CharacterBody2D:
					if collider.is_in_group("player"):
						player.player_take_dmg(75)
						break
		return
	$RayCast2D.target_position = $RayCast2D.to_local(player.global_position)
	var target_angle = (player.global_position - global_position).angle()
	shield.rotation = lerp_angle(shield.rotation, target_angle, rot_speed * _delta)
	walk()
	chose_attack()
	velocity = direction * speed
	$body/head.look_at(player.global_position)
	sword.look_at(player.global_position)
	move_and_slide()


func walk() -> void:
	if !player:
		return
	var player_cords = player.global_position
	if distance(global_position, player_cords) < 150:
		$body/legs.play("default")
		speed = 60
		var opposite: Vector2 = -(global_position - player_cords)
		nav_agent.target_position = opposite
	elif (
		200 > distance(global_position, player_cords)
		and distance(global_position, player_cords) > 150
	):
		speed = 0
		nav_agent.target_position = global_position
		$body/legs.stop()
	else:
		$body/legs.play("default")
		speed = 30
		nav_agent.target_position = player_cords
	var next_pos = nav_agent.get_next_path_position()
	legs.look_at(next_pos)
	direction = global_position.direction_to(next_pos)


func chose_attack() -> void:
	if in_cooldown or dead:
		return
	if can_see_player():
		charge()
	else:
		fire_hoaming_rocket()
	in_cooldown = true
	get_tree().create_timer(attack_cooldonwn).timeout.connect(end_cooldown)


func end_cooldown() -> void:
	in_cooldown = false
	laucher.play("on")


func distance(pos_a: Vector2, pos_b: Vector2) -> float:
	var diff := pos_a - pos_b
	return diff.length()


func take_damage(damage: int, _knockback: int) -> void:
	health -= damage
	damage_effect()
	if health <= 0:
		die()


func die() -> void:
	pass  #TODO


func damage_effect() -> void:
	if health > 0:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE


func fire_laucher(cooldown: float = 0.3) -> void:
	if dead:
		return
	await rotate_by(laucher, (player.global_position - global_position).rotated(0.05).angle())
	spanwn_rocket(0)
	if dead:
		return
	await get_tree().create_timer(cooldown).timeout
	spanwn_rocket(0.15)
	spanwn_rocket(-0.15)
	if dead:
		return
	await get_tree().create_timer(cooldown).timeout
	spanwn_rocket(0)
	laucher.play("off")


func spanwn_rocket(rot_degree: float) -> void:
	var dir = (rocket_directory.global_position - rocket_spawn.global_position).normalized()
	var rocket: Node = rocket_pack.instantiate()
	rocket.global_position = rocket_spawn.global_position
	rocket.look_at(rocket_directory.global_position)
	rocket.direction = dir.rotated(rot_degree)
	rocket.rotate(rot_degree)
	curr_floor.add_child(rocket)


func fire_hoaming_rocket() -> void:
	var dir = (rocket_directory.global_position - rocket_spawn.global_position).normalized()
	var hrocket = hrocket_pack.instantiate()
	await rotate_by(laucher, (player.global_position - global_position).rotated(-1).angle())
	hrocket.global_position = rocket_spawn.global_position
	hrocket.look_at(rocket_directory.global_position)
	hrocket.direction = dir
	curr_floor.add_child(hrocket)


func fire_above(spawn_range: Vector2 = Vector2(80, 80)) -> void:
	await rotate_by(laucher, (player.global_position - global_position).rotated(0.05).angle())
	laucher.play("default")
	await laucher.animation_finished
	var spawn_area: Array[Vector2] = [
		player.global_position - spawn_range, player.global_position + spawn_range
	]
	for i in range(4):
		var spawn_x = randf_range(spawn_area[0].x, spawn_area[1].x)
		var spawn_y = randf_range(spawn_area[0].y, spawn_area[1].y)
		var daneger_zone: Area2D = danger_zone_pack.instantiate()
		daneger_zone.waiting_time = 0.5
		daneger_zone.global_position = Vector2(spawn_x, spawn_y)
		curr_floor.add_child(daneger_zone)
	laucher.play("empty")


func can_see_player() -> bool:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		return collider.is_in_group("player")
	return true


func rotate_by(item: Node2D, angle: float, time: float = 0.1) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(item, "rotation", angle, time)
	await tween.finished


func charge() -> void:
	is_charging = true
	var charge_dir: Vector2 = (player.global_position - global_position).normalized()
	rotate_by(shield, 0)
	rotate_by(sword, 0)
	rotate_by(laucher, -1.8)
	rotate_by(legs, 0)
	rotate_by($body/head, 0)
	await rotate_by($body, charge_dir.angle())
	velocity = charge_dir * charge_speed
	add_ghosts(charge_dir)


func add_ghosts(dir: Vector2):
	while is_charging:
		var ghost = ghost_pack.instantiate()
		ghost.global_position = global_position
		ghost.look_at(dir)
		get_tree().current_scene.add_child(ghost)
		await get_tree().create_timer(0.01).timeout
