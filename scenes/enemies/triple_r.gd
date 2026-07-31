extends AnimatedSprite2D
var can_attack = true
var bullet_pack = preload("res://scenes/effects/rocket.tscn")
var cooldown = 0
var skin
var target = Vector2(0, 0)
@onready var  rockerter: EnemyWithGun = get_parent().get_parent()


func _process(_delta: float) -> void:
	look_at(target)


func end_cd():
	can_attack = true


func attack():
	var rot=-0.25
	for i in range(3):
		var bullet = bullet_pack.instantiate()
		bullet.perce = 0
		bullet.dmg = 25
		bullet.shot_by_player = false
		bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
		bullet.direction = bullet.direction.rotated(rot)
		get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
		bullet.global_position = $Marker2D2.global_position
		bullet.look_at($Marker2D.global_position)
		bullet.rotate(rot)
		rot+=0.25