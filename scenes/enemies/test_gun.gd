extends AnimatedSprite2D
var can_attack = true
var bullet_test = preload("res://scenes/effects/bullet_test.tscn")
var cooldown=1
@export var mirrored=false
var target:Vector2


func _ready() -> void:
	if mirrored:
		scale=Vector2(1,-1)
		
func _process(_delta: float) -> void:
	look_at(target)

func end_cd():
	can_attack=true

func attack():
	if can_attack:
		var random_angle
		var bullet = bullet_test.instantiate()
		random_angle = deg_to_rad(randf_range(-5, 5))
		bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
		bullet.direction=bullet.direction.rotated(random_angle)
		get_tree().get_first_node_in_group("game").curr_scene.real_curr_floor.add_child(bullet)
		bullet.global_position=$Marker2D2.global_position
		bullet.look_at($Marker2D.global_position)
		can_attack=false
		play("default")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
