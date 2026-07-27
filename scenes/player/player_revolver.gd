extends AnimatedSprite2D
var can_attack: bool = true
var bullet_test: PackedScene = preload("res://scenes/effects/bullet_test.tscn")
var cooldown: float = 0.3
var is_owned_by_player: bool = true
var skin: String


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func end_cd() -> void:
	can_attack=true

## Fires a single bullet toward the cursor if the muzzle is clear.
func attack() -> void:
	if can_attack:
		if not is_hand_in_wall():
			var random_angle: float
			var bullet: Area2D = bullet_test.instantiate()
			random_angle = deg_to_rad(randf_range(-4, 4))
			bullet.shot_by_player=true
			bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
			bullet.direction=bullet.direction.rotated(random_angle)
			bullet.global_position=$Marker2D2.global_position
			get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet) 
			bullet.look_at($Marker2D.global_position)
		can_attack=false
		play("0")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)

func is_hand_in_wall() -> bool:
	var bodies: Array[Node2D] = $Area2D.get_overlapping_bodies()
	for body: Node2D in bodies:
			if not body.is_in_group("enemies") and not body.is_in_group("player"):
				return true
	return false
