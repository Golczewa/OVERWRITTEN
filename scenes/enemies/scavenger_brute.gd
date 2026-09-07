extends Enemy

# @export var test_max_health: int = 60
# @onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
# @onready var player = get_tree().get_first_node_in_group("player")
# @onready var weapon: Area2D = $AnimatedSprite2D/Area2D
# @onready var legs = $AnimatedSprite2D/AnimatedSprite2D2
# @onready var arrow: AnimatedSprite2D = $AnimatedSprite2D2
# var curr_health: int
# var direction: Vector2 = Vector2.ZERO
# var speed: int = 50
# var rot_speed: int = 15
# var floor_
# var view_distance: int = 250
# var player_sighted: bool = false
# var in_knocback: bool = false
# var dead = false
# var can_attack = false
# var spawn_dest = Vector2.ZERO
# var is_spawning = false
# @export var walk_range: int = 200

var damage := 30


func _engage() -> void:
	curr_speed = chase_speed
	if not in_cooldown and is_player_in() and not is_spawning:
		_attack()
	nav_agent.target_position = player.global_position
	var next_pos = nav_agent.get_next_path_position()
	body.look_at(player.global_position)
	direction = global_position.direction_to(next_pos)


func _attack() -> void:
	in_cooldown = true
	weapon.play("2")
	await get_tree().create_timer(0.1).timeout
	for node: Node2D in $AnimatedSprite2D/AnimatedSprite2D/Area2D.get_overlapping_bodies():
		if node.is_in_group("player"):
			node.player_take_dmg(damage)
			AudioPlayer.play_game_sfx(AudioPlayer.slash)
		else:
			AudioPlayer.play_game_sfx(AudioPlayer.swosh)
	await weapon.animation_finished
	weapon.frame = 0
	print(weapon.frame)
	get_tree().create_timer(cooldown_time).timeout.connect(end_cooldown)


func is_player_in() -> bool:
	for node: Node2D in $AnimatedSprite2D/AnimatedSprite2D/Area2D.get_overlapping_bodies():
		if node == player:
			return true
	return false
