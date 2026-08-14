extends CharacterBody2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var boss_bar: Control = player.get_node("Camera2D/CanvasLayer/ProgressBar2")
@onready var shield: StaticBody2D = $body/shield
@onready var legs: AnimatedSprite2D = $body/legs
@onready var sword: AnimatedSprite2D = $body/sword
@onready var laucher: AnimatedSprite2D = $body/laucher
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var max_health := 500
var speed := 30
var in_cutscene := false
var rot_speed := 15
var shield_rot_speed := 5
var dead := false
var direction := Vector2.ZERO
var in_cooldown := false


func _physics_process(_delta: float) -> void:
	if in_cutscene:
		return
	velocity = direction * speed
	$body/head.look_at(player.global_position)
	move_and_slide()


func walk() -> void:
	var player_cords = player.global_position
	if distance(global_position, player_cords) < 50:
		speed = 60
		nav_agent.target_position = -player_cords
	else:
		speed = 30
		nav_agent.target_position = player_cords
	var next_pos = nav_agent.get_next_path_position()
	legs.look_at(next_pos)
	direction = global_position.direction_to(next_pos)


func distance(pos_a: Vector2, pos_b: Vector2) -> float:
	var diff := pos_a - pos_b
	return diff.length()
