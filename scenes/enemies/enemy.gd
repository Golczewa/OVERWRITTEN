extends CharacterBody2D

class_name Enemy

@export var max_heatlh: int = 40
@export var nav_agent: NavigationAgent2D
@export var arrow: AnimatedSprite2D
@export var melle: bool = false
@export var sight: RayCast2D
@export var legs: AnimatedSprite2D
@export var body: AnimatedSprite2D
@export var knockback_marker: Marker2D
@export var to_hide_on_death: Array[Node] = []
@export var with_warning: bool = false
@export var patrol_speed: int = 50
@export var chase_speed: int = 150
@export var rot_speed: int = 15
@export var view_distance: int = 200
@export var attack_range: int = 150
@export var walk_range: int = 200
@export var main_collison: CollisionShape2D
@export var weapon: AnimatedSprite2D
@export var weapon_offset: float = 0
@export var cooldown_time: float = 1

@onready var warning_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var curr_floor: Floor = get_parent().get_parent()

var player_sighted: bool = false
var in_knocback: bool = false
var in_range: bool = false
var direction: Vector2 = Vector2.ZERO
var dead := false
var spawn_dest := Vector2.ZERO
var is_spawning := false
var can_attack: bool = false
var curr_health: int
var curr_speed: int
var in_cooldown: bool = false
var triggered: bool = false
signal died


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


func _physics_process(_delta: float) -> void:
	if is_spawning or dead:
		return
	if in_knocback:
		velocity = direction * curr_speed
		move_and_slide()
		return
	arrow.update_arrow_pos(global_position, player.camera)
	sight.target_position = sight.to_local(player.global_position)
	if player_sighted and not player.invisible:
		_engage()
	else:
		idle()
	velocity = direction * curr_speed
	if not player_sighted:
		if (global_position - player.global_position).length() <= view_distance:
			player_sighted = can_see_player()
	if not triggered and player_sighted:
		trigger_others()
	move_and_slide()


func can_see_player() -> bool:
	if sight.is_colliding():
		var collider = sight.get_collider()
		return collider == player
	return false


func idle():
	legs.walk()
	if nav_agent.is_navigation_finished():
		direction = Vector2.ZERO
		curr_speed = patrol_speed
		var rand_pos = (
			global_position
			+ Vector2(randf_range(-walk_range, walk_range), randf_range(-walk_range, walk_range))
		)
		nav_agent.target_position = rand_pos
		return
	var next_path = nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)
	if (not melle) and direction:
		weapon.look_at(next_path.rotated(weapon_offset))
	body.look_at(next_path)
	legs.toogle_fallow(next_path)


##fighting logic
func _engage() -> void:
	pass


##weapon logic
func _attack() -> void:
	pass


func take_damage(damage: int, knockback: int):
	player_sighted = true
	if is_spawning:
		return
	curr_health = curr_health - damage
	if knockback != 0:
		var org_speed = curr_speed
		curr_speed = knockback
		legs.stop()
		if direction == Vector2.ZERO:
			direction = Vector2(knockback_marker.global_position - global_position).normalized()
		else:
			direction = -direction
		in_knocback = true
		get_tree().create_timer(0.1).timeout.connect(end_knockback.bind(org_speed))
	if damage != 0:
		_damage_effect()
	if (!player_sighted) and not player.invisible:
		player_sighted = true
	if curr_health <= 0 and not dead:
		die()


func die():
	AudioPlayer.play_game_sfx(AudioPlayer.death)
	died.emit()
	curr_floor.enemies -= 1
	dead = true
	body.animation = "dead"
	body.frame = randi_range(0, 3)
	z_index = 0
	modulate = Color(0.25, 0.25, 0.25)
	main_collison.set_deferred("disabled", true)
	for node in to_hide_on_death:
		if node:
			node.hide()


func _damage_effect():
	if curr_health > 0:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
	if curr_health > 0:
		modulate = Color.WHITE


func big_entrance(pos: Vector2) -> void:
	look_at(pos + Vector2(1, 1))
	legs.walk()
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


func trigger():
	if not player.invisible:
		player_sighted = true


func end_knockback(org_speed):
	curr_speed = 0
	direction = -direction
	await get_tree().create_timer(1).timeout
	legs.walk()
	curr_speed = org_speed
	in_knocback = false


func end_cooldown():
	in_cooldown = false


func trigger_others():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy is Enemy:
			enemy.trigger()
	triggered = true


func get_opposite(retreat := 60) -> Vector2:
	var opposite = (global_position - player.global_position).normalized()
	return global_position + opposite * retreat
