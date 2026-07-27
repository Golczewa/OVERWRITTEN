extends CharacterBody2D

@export var test_max_health: int =50
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var weapon: Area2D = $AnimatedSprite2D/Area2D
var curr_health: int
var direction: Vector2 = Vector2.ZERO
var speed: int =50
var rot_speed: int =15
var floor_: Floor
var view_distance: int =250
var player_sighted: bool = false
var in_knocback: bool = false
var dead: bool = false
var can_attack: bool = false
@export var walk_range: int =200

signal died

func _ready() -> void:
		floor_=get_parent().get_parent()
		if nav_agent.get_navigation_map() != get_world_2d().get_navigation_map():
			nav_agent.set_navigation_map(get_world_2d().get_navigation_map())
		floor_.enemies=floor_.enemies+1
		weapon.body_entered.connect(player_in)
		weapon.body_exited.connect(player_out)
		curr_health=test_max_health
		_randomise_target()
		
## Applies damage and optional knockback to this enemy.
func take_damage(damage: int, knockback: int) -> void:
	curr_health=curr_health-damage
	if(knockback!=0):
		var org_speed: int = speed
		speed=knockback
		if(direction==Vector2.ZERO):
			direction=-Vector2($AnimatedSprite2D/RayCast2D.target_position-global_position).normalized()
		else:
			direction=-direction
		in_knocback=true
		get_tree().create_timer(0.1).timeout.connect(end_knockback.bind(org_speed))
	_damage_effect()
	if(!player_sighted):
		player_sighted=true
	if curr_health<=0:
		_die()

func end_knockback(org_speed: int) -> void:
	speed=0
	direction=-direction
	await get_tree().create_timer(1).timeout
	speed=org_speed
	in_knocback=false

func _die() -> void:
	dead=true
	floor_.enemies=floor_.enemies-1
	emit_signal("died")
	$AnimatedSprite2D.play("dead")
	modulate = Color.GRAY
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D/RayCast2D.set_deferred("disabled", true)
	remove_from_group("enemies")

func _damage_effect() -> void:
	modulate=Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate=Color.WHITE

func _idle_moving() -> void:
	if nav_agent.is_navigation_finished():
		speed=50
		rot_speed=15
		direction=Vector2.ZERO
		_randomise_target()
		return
	var next_path: Vector2 = nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)

func _randomise_target() -> void:
	var x: float = randf_range(-walk_range,walk_range)
	var y: float = randf_range(-walk_range,walk_range)
	var target: Vector2 = global_position+Vector2(x,y)
	nav_agent.target_position=target

func _physics_process(_delta: float) -> void:
	if(!in_knocback):
		if(player_sighted):
			chase()
		else: 
			_idle_moving()
		var target_angle: float = direction.angle()
		rotation = lerp_angle(rotation, target_angle, rot_speed * _delta)
	velocity=direction*speed
	if(!player_sighted):
		player_sighted=can_see_player()
		if player_sighted:
			get_tree().call_group("enemies","trigger")
	if can_attack:
		weapon.attack()
	move_and_slide()

func can_see_player() -> bool:
	var dist: float = global_position.distance_to(player.global_position)
	if dist > view_distance:
		return false
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.collision_mask = 3 
	query.exclude = [self.get_rid()]
	var result: Dictionary = space_state.intersect_ray(query)
	if result:
		if result.collider == player:
			return true
	return false

func chase() -> void:
	speed=200
	rot_speed=20
	nav_agent.target_position=player.global_position
	if nav_agent.is_navigation_finished():
		direction = global_position.direction_to(player.global_position)
	else:
		var next_path: Vector2 = nav_agent.get_next_path_position()
		direction = global_position.direction_to(next_path)

func player_in(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		can_attack=true

func player_out(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		can_attack=false

## Forces this enemy to start chasing the player.
func trigger() -> void:
	player_sighted=true
