extends CharacterBody2D

@export var sight: RayCast2D
@export var machete: AnimatedSprite2D
@export var gun: AnimatedSprite2D
@export var body: AnimatedSprite2D
@export var to_hide_on_death: Array[Node2D]

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var legs = $AnimatedSprite2D3
@onready var arrow: AnimatedSprite2D = $AnimatedSprite2D2
@onready var boss_bar = player.get_node("Camera2D/CanvasLayer/ProgressBar2")
@onready var coat_pack: PackedScene = preload("res://scenes/player/coat.tscn")
@onready var bullet_pack: PackedScene = preload("res://scenes/effects/bullet_test.tscn")

var max_health: int = 300
var curr_health: int
var direction: Vector2 = Vector2.ZERO
var gunner_speed: int = 100
var curr_speed: int = gunner_speed
var scavenger_speed: int = 300
var rot_speed: int = 15
@onready var floor_: Floor = get_parent().get_parent()
var view_distance: int = 300
var in_knocback: bool = false
var dead = false
var can_attack = false
var range_: int = 400
var in_cutscene: bool = false
var in_cooldown: bool = true
enum Mode { gunner, scavenger }
var curr_mode: Mode = Mode.gunner
var closeup = 250
var standing_room = 75
var gunner_cyckle: Array[int] = get_new_cycle()
var cycle_num := 0
var gunner_cooldown := 0.6
var in_sword_cooldown := false
var sword_cooldown := 1.5

signal died


func _ready() -> void:
	curr_health = max_health
	legs.walk()
	get_tree().create_timer(gunner_cooldown).timeout.connect(end_cooldown)


func _physics_process(_delta: float) -> void:
	if in_cutscene:
		return
	if in_knocback:
		velocity = direction * curr_speed
		move_and_slide()
		return
	if curr_mode == Mode.gunner:
		gunner()
	else:
		scavenger()
	if is_player_in():
		scavenger_attack()
	sight.target_position = sight.to_local(player.global_position)
	arrow.update_arrow_pos(global_position, player.camera)
	gun.look_at(player.global_position)
	velocity = curr_speed * direction
	move_and_slide()


func gunner():
	var stand := false
	curr_speed = gunner_speed
	if not in_cooldown and can_see_player():
		gunner_attack()
	var player_distance: float = (player.global_position - global_position).length()
	if player_distance < closeup and can_see_player():
		legs.walk()
		nav_agent.target_position = get_opposite()
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


func gunner_attack():
	in_cooldown = true
	if gunner_cyckle[cycle_num] == 0:
		burst()
	else:
		spawn_bullet()
	cycle_num += 1
	get_tree().create_timer(gunner_cooldown).timeout.connect(end_cooldown)
	if cycle_num >= gunner_cyckle.size() - 1:
		cycle_num = 0
		gunner_cyckle = get_new_cycle()
		curr_mode = Mode.scavenger
		get_tree().create_timer(randf_range(2, 4)).timeout.connect(to_scavenger)


func burst():
	gun.play("spin")
	$AnimatedSprite2D/AnimatedSprite2D/Sprite2D.show()
	var tween := create_tween()
	tween.tween_property($AnimatedSprite2D/AnimatedSprite2D/Sprite2D, "rotation", 6.28, 0.3)
	await AudioPlayer.play_game_sfx(AudioPlayer.revolver_spin)
	$AnimatedSprite2D/AnimatedSprite2D/Sprite2D.hide()
	$AnimatedSprite2D/AnimatedSprite2D/Sprite2D.rotation = 0
	gun.play("default")
	for i in range(6):
		if dead or in_knocback:
			break
		spawn_bullet(15)
		await get_tree().create_timer(0.1).timeout


func scavenger():
	legs.run()
	curr_speed = scavenger_speed
	nav_agent.target_position = player.global_position
	var next_pos = nav_agent.get_next_path_position()
	legs.toogle_fallow(next_pos)
	body.look_at(player.global_position)
	direction = global_position.direction_to(next_pos)


func scavenger_attack(damage = 30) -> void:
	if in_sword_cooldown:
		return
	in_sword_cooldown = true
	machete.play("default")
	await get_tree().create_timer(0.1).timeout
	for node: Node2D in $AnimatedSprite2D/AnimatedSprite2D2/Area2D.get_overlapping_bodies():
		if node.is_in_group("player"):
			node.player_take_dmg(damage)
			AudioPlayer.play_game_sfx(AudioPlayer.slash)
		else:
			AudioPlayer.play_game_sfx(AudioPlayer.swosh)
	await machete.animation_finished
	machete.frame = 0
	get_tree().create_timer(sword_cooldown).timeout.connect(end_sword_cooldown)


func take_damage(damage: int, knockback: int):
	if in_cutscene:
		return
	curr_health = curr_health - damage
	boss_bar.update(curr_health)
	if knockback != 0:
		legs.stop_walking()
		var org_speed = curr_speed
		curr_speed = knockback
		if direction == Vector2.ZERO:
			direction = -(
				Vector2($AnimatedSprite2D/RayCast2D.target_position - global_position).normalized()
			)
		else:
			direction = -direction
		in_knocback = true
		get_tree().create_timer(0.1).timeout.connect(end_knockback.bind(org_speed))
	_damage_effect()
	if curr_health <= 0 and not dead:
		_die()


func end_knockback(org_speed):
	curr_speed = 0
	direction = -direction
	await get_tree().create_timer(1).timeout
	curr_speed = org_speed
	in_knocback = false


func _die():
	dead = true
	floor_.enemies = floor_.enemies - 1
	emit_signal("died")
	$AnimatedSprite2D.play("dead")
	z_index = 0
	modulate = Color(0.25, 0.25, 0.25)
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	legs.stop_walking()
	for node in to_hide_on_death:
		node.hide()
	boss_bar.boss_is_out()
	remove_from_group("enemies")
	drop_cloth()


func _damage_effect():
	if curr_health > 0:
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
	if curr_health > 0:
		modulate = Color.WHITE


func toogle_cutscene() -> bool:
	in_cutscene = !in_cutscene
	return in_cutscene


func drop_cloth():
	var coat: Node2D = coat_pack.instantiate()
	get_parent().get_parent().add_child(coat)
	coat.global_position = global_position


func can_see_player() -> bool:
	if sight.is_colliding():
		var collider = sight.get_collider()
		return collider == player
	return false


func get_opposite(retreat := 60) -> Vector2:
	var opposite = (global_position - player.global_position).normalized()
	return global_position + opposite * retreat


func get_new_cycle() -> Array[int]:
	var arr: Array[int]
	for i: int in range(randi_range(5, 8)):
		arr.append(i)
	arr.shuffle()
	return arr


func spawn_bullet(damage := 20):
	AudioPlayer.play_game_sfx(AudioPlayer.revolver_shot, 6)
	var spawn_marker: Marker2D = $AnimatedSprite2D/AnimatedSprite2D/Marker2D
	var dir_marker: Marker2D = $AnimatedSprite2D/AnimatedSprite2D/Marker2D2
	var random_angle
	var bullet = bullet_pack.instantiate()
	bullet.dmg = damage
	random_angle = deg_to_rad(randf_range(-2, 2))
	bullet.direction = (dir_marker.global_position - spawn_marker.global_position).normalized()
	bullet.direction = bullet.direction.rotated(random_angle)
	floor_.add_child(bullet)
	bullet.global_position = spawn_marker.global_position
	bullet.look_at(dir_marker.global_position)


func end_cooldown():
	in_cooldown = false


func end_sword_cooldown():
	in_sword_cooldown = false


func is_player_in() -> bool:
	for node: Node2D in $AnimatedSprite2D/AnimatedSprite2D2/Area2D.get_overlapping_bodies():
		if node == player:
			return true
	return false


func to_scavenger():
	curr_mode = Mode.gunner
