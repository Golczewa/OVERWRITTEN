extends AnimatedSprite2D
var can_attack = true
var bullet_test = preload("res://scenes/effects/bullet_test.tscn")
var cooldown = 1
var skin
var target = Vector2(0, 0)
@onready var hunter: EnemyWithGun = get_parent().get_parent()


func _process(_delta: float) -> void:
	look_at(target)


func end_cd():
	can_attack = true


func attack():
	if can_attack:
		can_attack = false
		for i in range(0, 3):
			if hunter.dead or hunter.in_knocback:
				break
			AudioPlayer.play_game_sfx(AudioPlayer.patchwork_shot, 4)
			var random_angle
			var bullet = bullet_test.instantiate()
			bullet.perce = 0
			bullet.dmg = 15
			random_angle = deg_to_rad(randf_range(-2, 2))
			bullet.shot_by_player = false
			bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
			bullet.direction = bullet.direction.rotated(random_angle)
			get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
			bullet.global_position = $Marker2D2.global_position
			bullet.look_at($Marker2D.global_position)
			await get_tree().create_timer(0.2).timeout
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
