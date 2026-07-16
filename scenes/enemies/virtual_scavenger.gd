extends CharacterBody2D

@export var test_max_health: int =1
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var legs=$AnimatedSprite2D2
var curr_health: int
var floor_
var direction: Vector2 = Vector2.ZERO
var speed: int=70
var rot_speed: int =15
var view_distance: int =250
var player_sighted:bool = false
var in_knocback:bool=false
var in_range:bool=false
var walk_range: int =200
var range_:int=400
var dead=false
signal died

func _ready() -> void:
		randomize()
		floor_=get_parent().get_parent()
		floor_.enemies=floor_.enemies+1
		curr_health=test_max_health
		legs.walk()
		$AnimatedSprite2D.play("default")
		_randomise_target()
		
func take_damage(damage: int,_knockback:int):
	curr_health=curr_health-damage
	if curr_health<=0 and not dead:
		_die()



func  _die():
	floor_.enemies=floor_.enemies-1
	$CollisionShape2D.set_deferred("disabled",true)
	$PointLight2D.hide()
	var tween = create_tween().set_parallel(true)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0,0), 0.2)
	tween.tween_property($AnimatedSprite2D, "modulate:a",0, 0.2)
	tween.tween_property($AnimatedSprite2D2, "scale", Vector2(0,0), 0.2)
	tween.tween_property($AnimatedSprite2D2, "modulate:a",0, 0.2)
	dead=true
	set_physics_process(false)
	set_process(false)


func _idle_moving():
	if nav_agent.is_navigation_finished():
		speed=50
		rot_speed=15
		direction=Vector2.ZERO
		_randomise_target()
		return
	var next_path=nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)

func _randomise_target():
	var x=randf_range(-walk_range,walk_range)
	var y=randf_range(-walk_range,walk_range)
	var target=global_position+Vector2(x,y)
	nav_agent.target_position=target

func _physics_process(_delta: float) -> void:
	if(!in_knocback):
			_idle_moving()
			var target_angle = direction.angle()
			rotation = lerp_angle(rotation, target_angle, rot_speed * _delta)
	velocity=direction*speed
	move_and_slide()



func is_path_blocked():
	$AnimatedSprite2D/AnimatedSprite2D2/RayCast2D.target_position=Vector2(range_,0)
	if $AnimatedSprite2D/AnimatedSprite2D2/RayCast2D.is_colliding():
		var collider=$AnimatedSprite2D/AnimatedSprite2D2/RayCast2D.get_collider()
		if collider and collider.is_in_group("player"):
			return false
		else:
			return true
	return false
