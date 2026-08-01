extends AnimatedSprite2D
var can_attack = true
var bullet_pack = preload("res://scenes/effects/rocket.tscn")
var cooldown = 2
var skin
var target = Vector2(0, 0)
@onready var rockerter: EnemyWithGun = get_parent().get_parent()


func _process(_delta: float) -> void:
	look_at(target)


func end_cd():
	play("default")
	can_attack = true


func attack():
	if can_attack:
		can_attack = false
		var rot = -0.35
		for i in range(3):
			var bullet = bullet_pack.instantiate()
			bullet.perce = 0
			bullet.dmg = 25
			bullet.shot_by_player = false
			bullet.direction = ($Marker2D2.global_position - $Marker2D.global_position).normalized()
			bullet.direction = bullet.direction.rotated(rot)
			get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
			bullet.global_position = $Marker2D.global_position
			bullet.look_at($Marker2D2.global_position)
			bullet.rotate(rot)
			rot += 0.35
		play("cd")
		rockerter.take_damage(0, 100)
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
