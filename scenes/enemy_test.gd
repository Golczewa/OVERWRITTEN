extends CharacterBody2D

@export var test_max_health: int =100
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")
var curr_health: int
var direction: Vector2 = Vector2.ZERO
var speed: int=50
var rot_speed: int =15
var view_distance: int =250
@export var walk_range: int =200
signal died

func _ready() -> void:
		curr_health=test_max_health
		_randomise_target()
		
func take_damage(damage: int):
	curr_health=curr_health-damage
	_damage_effect()
	if curr_health<=0:
		_die()

func  _die():
	emit_signal("died")
	queue_free()

func _damage_effect():
	modulate=Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate=Color.WHITE

func _idle_moving():
	if nav_agent.is_navigation_finished():
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
	_idle_moving()
	var target_angle = direction.angle()
	rotation = lerp_angle(rotation, target_angle, rot_speed * _delta)
	velocity=direction*speed
	if(can_see_player()):
		queue_free()
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
