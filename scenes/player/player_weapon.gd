extends AnimatedSprite2D

class_name PlayerWeapon

var can_attack = true

@export var cooldown = 0.6
@export var bullet_pack:PackedScene
@export var bullet_spawn:Marker2D
@export var bullet_director:Marker2D
@export var weapon_area:Area2D

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func end_cd():
	can_attack = true


func _attack():
	if can_attack:
		get_tree().create_timer(cooldown).timeout.connect(end_cd)


func is_hand_in_wall():
	var bodies = weapon_area.get_overlapping_bodies()
	for body in bodies:
		if not body.is_in_group("enemies") and not body.is_in_group("player"):
			return true
	return false


func _spawn_bullet():
	var bullet = bullet_pack.instantiate()
	bullet.perce = 0
	bullet.dmg = 15
	var random_angle = deg_to_rad(randf_range(-2, 2))
	bullet.shot_by_player = true
	var spawn_pos = bullet_spawn.global_position
	var spawn_dir = (bullet_director.global_position - spawn_pos).normalized().rotated(random_angle)
	bullet.direction = spawn_dir
	bullet.global_position = spawn_pos
	get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
	bullet.look_at(bullet_director.global_position)

