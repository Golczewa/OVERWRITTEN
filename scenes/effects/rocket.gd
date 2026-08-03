extends Area2D
var speed: int = 400
var perce: int = 0
var perced: int = 0
var dmg: int = 35
var velocity
var direction
var target
var shot_by_player: bool = false
var trace_len = 3
var bullet_hit_wall = preload("res://scenes/effects/rocket_explosion.tscn")
var bullet_hit_wall_inst


func _ready() -> void:
	body_entered.connect(_on_body_enterd)
	velocity = direction * speed
	bullet_hit_wall_inst = bullet_hit_wall.instantiate()
	$RayCast2D.target_position = Vector2((speed) * get_physics_process_delta_time(), 0)
	$AnimatedSprite2D.play("default")


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


func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if not collider.is_in_group("enemies") and not collider.is_in_group("player"):
			bullet_hit_wall_inst.global_position = $RayCast2D.get_collision_point()
			bullet_hit_wall_inst.rotation = velocity.angle()
			get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(
				bullet_hit_wall_inst
			)
			queue_free()
		elif collider.is_in_group("window"):
			collider.shatter(self)
	position = position + velocity * delta
