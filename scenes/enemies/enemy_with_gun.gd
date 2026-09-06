class_name EnemyWithGun
extends CharacterBody2D

@export var max_health: int = 40
@export var with_warning: bool = false
@onready var warning_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")
@export var weapon: AnimatedSprite2D
@export var legs: AnimatedSprite2D
@export var body: AnimatedSprite2D
@export var raycast: RayCast2D
@export var marker: Marker2D
@export var arrow: AnimatedSprite2D
@export var to_hide_on_death: Array[Node] = []
var curr_health: int
var floor_
var direction: Vector2 = Vector2.ZERO
var speed: int = 50
@export var patrol_speed: int = 50
@export var chase_speed: int = 150
@export var rot_speed: int = 15
@export var view_distance: int = 250
var player_sighted: bool = false
var in_knocback: bool = false
var in_range: bool = false
@export var walk_range: int = 200
@export var range_: int = 400
var dead = false
var spawn_dest = Vector2.ZERO
var is_spawning = false
var can_attack: bool = false
signal died


func _ready() -> void:
	body.play("default")
	if spawn_dest != Vector2.ZERO and is_spawning:
		await big_entrance(spawn_dest)
		trigger()
		
	randomize()
	floor_ = get_parent().get_parent()
	floor_.enemies = floor_.enemies + 1
	curr_health = max_health
	legs.walk()
	_randomise_target()


func take_damage(damage: int, knockback: int):
	if not is_spawning:
		curr_health = curr_health - damage
		if knockback != 0:
			var org_speed = speed
			speed = knockback
			legs.stop()
			if direction == Vector2.ZERO:
				direction = Vector2(marker.global_position - global_position).normalized()
			else:
				direction = -direction
			in_knocback = true
			get_tree().create_timer(0.1).timeout.connect(end_knockback.bind(org_speed))
		if damage != 0:
			_damage_effect()
		if (!player_sighted) and not player.invisible:
			player_sighted = true
		if curr_health <= 0 and not dead:
			_die()


func end_knockback(org_speed):
	speed = 0
	direction = -direction
	await get_tree().create_timer(1).timeout
	legs.walk()
	speed = org_speed
	in_knocback = false


func _die():
	emit_signal("died")
	floor_.enemies = floor_.enemies - 1
	dead = true
	body.play("dead")
	body.stop()
	body.frame = (randi() % 3) + 1
	z_index = 0
	modulate = Color(0.25, 0.25, 0.25)
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	raycast.set_deferred("disabled", true)
	legs.stop()
	for node in to_hide_on_death:
		if node:
			node.hide()
	remove_from_group("enemies")


func _damage_effect():
	if curr_health > 0:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
	if curr_health > 0:
		modulate = Color.WHITE


func _idle_moving():
	if nav_agent.is_navigation_finished():
		speed = patrol_speed
		rot_speed = 15
		direction = Vector2.ZERO
		_randomise_target()
		return
	var next_path = nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)


func _randomise_target():
	var x = randf_range(-walk_range, walk_range)
	var y = randf_range(-walk_range, walk_range)
	var target = global_position + Vector2(x, y)
	nav_agent.target_position = target


func _physics_process(_delta: float) -> void:
	if not is_spawning:
		if !in_knocback:
			arrow.update_arrow_pos(global_position, player.camera)
			if player_sighted and not player.invisible:
				chase()
			else:
				_idle_moving()
				var offset = Vector2.RIGHT.rotated(rotation) * 100
				var target_pos = global_position + offset
				weapon.target = target_pos
				var target_angle = direction.angle()
				rotation = lerp_angle(rotation, target_angle, rot_speed * _delta)
		velocity = direction * speed
		if !player_sighted:
			player_sighted = can_see_player()
			if player_sighted:
				get_tree().call_group("enemies", "trigger")
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
	speed = chase_speed
	rot_speed = 20
	weapon.target = player.global_position
	body.look_at(player.global_position)
	if global_position.distance_to(player.global_position) <= range_ and not is_path_blocked():
		direction = Vector2.ZERO
		_fire_weapon()
		legs.stop_walking()
	else:
		if global_position.distance_to(player.global_position) <= range_ and not is_path_blocked():
			direction = Vector2.ZERO
		else:
			legs.walk()
			nav_agent.target_position = player.global_position
			var next_path = nav_agent.get_next_path_position()
			legs.toogle_fallow(next_path)
			direction = global_position.direction_to(next_path)


func is_path_blocked():
	raycast.target_position = Vector2(range_, 0)
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("player"):
			return false
		else:
			return true
	return false


func trigger():
	if not player.invisible:
		player_sighted = true


func big_entrance(pos: Vector2) -> void:
	look_at(pos + Vector2(1, 1))
	legs.walk()
	weapon.target = pos * 5
	weapon.show()
	modulate = Color.BLACK
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position", pos, 0.5)
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	await tween.finished
	is_spawning = false
	if with_warning:
		var warning = warning_pack.instantiate()
		player.canvas.add_child(warning)
		warning.setup(self, Vector2(64, 64), died, "An actual enemy!")


func _fire_weapon():
	if can_attack:
		weapon.attack()
	else:
		get_tree().create_timer(1).timeout.connect(set_can_attack)


func set_can_attack():
	can_attack = true
