extends AnimatedSprite2D
var can_attack = true
var bullet_test = preload("res://scenes/bullet_test.tscn")
var cooldown=1
var is_owned_by_player:bool
var target:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(get_parent().get_parent().is_in_group("player")):
		is_owned_by_player=true
		cooldown=0.3
		scale=Vector2(1,-1)

func _process(_delta: float) -> void:
	if(is_owned_by_player):
		look_at(get_global_mouse_position())
	else :
		look_at(target)

func end_cd():
	can_attack=true

func attack():
	if can_attack:
		var bullet = bullet_test.instantiate()
		if is_owned_by_player:
			bullet.shot_by_player=true
		bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
		get_tree().current_scene.add_child(bullet) 
		bullet.global_position=$Marker2D.global_position
		can_attack=false
		play("default")
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
