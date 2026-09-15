extends Area2D
var speed: int = 1500
var perce: int = 1
var perced: int = 0
var dmg: int = 20
var velocity: Vector2
var direction
var target
var shot_by_player: bool = false
var trace_len = 3
var bullet_hit_wall = preload("res://scenes/effects/shoot_the_wall.tscn")
var bullet_hit_wall_inst
var start_position: Vector2


func _ready() -> void:
	start_position = global_position
	body_entered.connect(_on_body_enterd)
	velocity = direction * speed
	bullet_hit_wall_inst = bullet_hit_wall.instantiate()
	$RayCast2D.target_position = Vector2((speed) * get_physics_process_delta_time(), 0)


func _on_body_enterd(body):
	if body.is_in_group("enemies"):
		if shot_by_player:
			body.take_damage(dmg, 0)
			if perced == perce:
				queue_free()
			perced = perced + 1
	elif body.is_in_group("player"):
		if not shot_by_player:
			body.player_take_dmg(dmg)
			if perced == perce:
				queue_free()
			perced = perced + 1


func _physics_process(delta: float) -> void:
	$Line2D.global_position = Vector2.ZERO
	$Line2D.global_rotation = 0
	var point = global_position
	$Line2D.add_point(point)
	if $Line2D.points.size() > trace_len:
		$Line2D.remove_point(0)
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
	position = position + velocity * delta
	if global_position.distance_to(start_position) > 1000:
		queue_free()
