extends CharacterBody2D

@export var test_max_health: int =40
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var weapon: AnimatedSprite2D=$AnimatedSprite2D/AnimatedSprite2D2
@onready var legs=$AnimatedSprite2D/AnimatedSprite2D3
var curr_health: int
var floor_
var direction: Vector2 = Vector2.ZERO
var speed: int=50
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
		floor_=get_parent().get_parent()
		floor_.enemies=floor_.enemies+1
		curr_health=test_max_health
		legs.walk()
		$AnimatedSprite2D.play("default")
		_randomise_target()
		
func take_damage(damage: int,knockback:int):
	curr_health=curr_health-damage
	if(knockback!=0):
		var org_speed=speed
		speed=knockback
		legs.stop()
		if(direction==Vector2.ZERO):
			direction=Vector2($Marker2D.global_position-global_position).normalized()
		else:
			direction=-direction
		in_knocback=true
		get_tree().create_timer(0.1).timeout.connect(end_knockback.bind(org_speed))
	_damage_effect()
	if(!player_sighted):
		player_sighted=true
	if curr_health<=0:
		_die()

func end_knockback( org_speed):
	speed=0
	direction=-direction
	await get_tree().create_timer(1).timeout
	legs.walk()
	speed=org_speed
	in_knocback=false

func  _die():
	emit_signal("died")
	floor_.enemies=floor_.enemies-1
	dead=true
	$AnimatedSprite2D.play("dead")
	$AnimatedSprite2D.frame=0
	modulate = Color.GRAY
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D/AnimatedSprite2D2/RayCast2D2.set_deferred("disabled", true)
	legs.visible=not legs.visible
	legs.stop()
	$AnimatedSprite2D/AnimatedSprite2D2.visible=not $AnimatedSprite2D/AnimatedSprite2D2.visible
	remove_from_group("enemies")

func _damage_effect():
	modulate=Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate=Color.WHITE

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
		if(player_sighted):
			chase()
		else: 
			_idle_moving()
			var offset = Vector2.RIGHT.rotated(rotation) * 100
			var target_pos = global_position + offset
			weapon.target = target_pos
			var target_angle = direction.angle()
			rotation = lerp_angle(rotation, target_angle, rot_speed * _delta)
	velocity=direction*speed
	if(!player_sighted):
		player_sighted=can_see_player()
		if player_sighted:
			get_tree().call_group("enemies","trigger")
	move_and_slide()

func can_see_player():
	var dist = global_position.distance_to(player.global_position)
	if dist > view_distance:
		return false
	var space_state=get_world_2d().direct_space_state
	var query=PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.collision_mask = 3 
	query.exclude = [self.get_rid()]
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider == player:
			return true
	return false

func  chase():
	speed=100
	rot_speed=20
	weapon.target=player.global_position
	look_at(player.global_position)
	if(global_position.distance_to(player.global_position)<=range_ and not is_path_blocked()):
		direction=Vector2.ZERO
		weapon.attack()
		legs.stop_walking()
	else:
		if global_position.distance_to(player.global_position)<=range_ and not is_path_blocked():
			direction=Vector2.ZERO
		else:
			legs.walk()
			nav_agent.target_position=player.global_position
			var next_path=nav_agent.get_next_path_position()
			direction = global_position.direction_to(next_path)

func is_path_blocked():
	$AnimatedSprite2D/AnimatedSprite2D2/RayCast2D2.target_position=Vector2(range_,0)
	if $AnimatedSprite2D/AnimatedSprite2D2/RayCast2D2.is_colliding():
		var collider=$AnimatedSprite2D/AnimatedSprite2D2/RayCast2D2.get_collider()
		if collider and collider.is_in_group("player"):
			return false
		else:
			return true
	return false

func trigger():
	player_sighted=true
