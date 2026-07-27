extends AnimatedSprite2D
var can_attack: bool = true
var bullet_test: PackedScene = preload("res://scenes/effects/bullet_test.tscn")
var cooldown: float = 0.6
var is_owned_by_player: bool = true
var skin: String


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func end_cd() -> void:
	can_attack=true

## Fires a spread of pellets if the muzzle is not blocked.
func attack() -> void:
	if can_attack:
		can_attack = false
		if not is_hand_in_wall():
			for i: int in range(0, 3):
				_spawn_bullet()
				await get_tree().create_timer(0.2).timeout
		play("0")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)

func is_hand_in_wall() -> bool:
	var bodies: Array[Node2D] = $Area2D.get_overlapping_bodies()
	for body: Node2D in bodies:
			if not body.is_in_group("enemies") and not body.is_in_group("player"):
				return true
	return false

func _spawn_bullet() -> void:
	var bullet: Area2D = bullet_test.instantiate()
	bullet.perce = 0
	bullet.dmg = 15
	var random_angle: float = deg_to_rad(randf_range(-2, 2))
	bullet.shot_by_player = true
	var spawn_pos: Vector2 = $Marker2D2.global_position
	var spawn_dir: Vector2 = ($Marker2D.global_position - spawn_pos).normalized().rotated(random_angle)
	bullet.direction = spawn_dir
	bullet.global_position = spawn_pos
	get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
	bullet.look_at($Marker2D.global_position)
