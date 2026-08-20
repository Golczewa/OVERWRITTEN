extends Node2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var leader = $CharacterBody2D


func _ready() -> void:
	leader.toogle_cutscene()
	$Area2D.body_entered.connect(play_cuscene)


func play_cuscene(body: Node2D):
	if body != player:
		return
	print("intro",body.global_position)
	player.in_cutscene = true
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	await player.focus_camera(leader.global_position)
	leader.charge_cutscene()
	await get_tree().create_timer(0.5).timeout
	$StaticBody2D.hide()
	$Sprite2D.show()
	$Sprite2D2.show()
	player.set_camera_fallow(leader)
	await leader.end_charge
	leader.turn_cutscene()
	await leader.boss_bar.boss_is_in("Hash V - Scavengers Leader", leader.max_health)
	player.retrun_camera()
	leader.rotation = 0
	player.in_cutscene = false
	var leader_pos = leader.global_position
	remove_child(leader)
	print(leader_pos)
	get_parent().add_enemy(leader, leader_pos)
	leader.toogle_cutscene()
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
