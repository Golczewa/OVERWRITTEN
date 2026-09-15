extends Area2D
var speed: int = 300
var perce: int = 0
var perced: int = 0
var dmg: int = 50
var living_time = 1.5
var hoaming = true
var velocity
var direction
var target
var shot_by_player: bool = false
var trace_len = 3
var bullet_hit_wall = preload("res://scenes/effects/rocket_explosion.tscn")
var bullet_hit_wall_inst
var player: CharacterBody2D
var sender: Node2D
var start_position:Vector2
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	start_position=global_position
	body_entered.connect(_on_body_enterd)
	bullet_hit_wall_inst = bullet_hit_wall.instantiate()
	$RayCast2D.target_position = Vector2((speed) * get_physics_process_delta_time(), 0)
	$AnimatedSprite2D.play("default")
	player = get_tree().get_first_node_in_group("player")
	get_tree().create_timer(living_time).timeout.connect(stop_hoaming)


func _on_body_enterd(body):
	if body.is_in_group("enemies"):
		if body == sender:
			body.take_damage(3 * dmg, 0)
			spawn_explosion()
			queue_free()
	elif body.is_in_group("player"):
		if not shot_by_player:
			body.player_take_dmg(dmg)
			if perced == perce:
				spawn_explosion()
				queue_free()
			perced = perced + 1


func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if (
			not collider.is_in_group("enemies")
			and not collider.is_in_group("player")
			and not collider.is_in_group("window")
		):
			bullet_hit_wall_inst.global_position = $RayCast2D.get_collision_point()
			bullet_hit_wall_inst.rotation = velocity.angle()
			get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(
				bullet_hit_wall_inst
			)
			queue_free()
		elif collider.is_in_group("window"):
			collider.shatter(self)
	if hoaming:
		travel()
		look_at(player.global_position)
	velocity = direction * speed
	position = position + velocity * delta
	if global_position.distance_to(start_position) > 1000:
		queue_free()


func spawn_explosion():
	bullet_hit_wall_inst.global_position = global_position
	bullet_hit_wall_inst.rotation = velocity.angle()
	get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(
		bullet_hit_wall_inst
	)


func travel():
	nav_agent.target_position = player.global_position
	var next_pos = nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_pos)


func stop_hoaming() -> void:
	hoaming = false
