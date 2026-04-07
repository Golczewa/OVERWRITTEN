extends CharacterBody2D

@export var test_max_health: int =100
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var curr_health: int
var direction: Vector2 = Vector2.ZERO
var speed: int=50

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
		_randomise_target()
		return
	var next_path=nav_agent.get_next_path_position()
	direction = global_position.direction_to(next_path)

func _randomise_target():
	var x=randf_range(-100,100)
	var y=randf_range(-100,100)
	var target=global_position+Vector2(x,y)
	nav_agent.target_position=target

func _physics_process(_delta: float) -> void:
	_idle_moving()
	velocity=direction*speed
	move_and_slide()
