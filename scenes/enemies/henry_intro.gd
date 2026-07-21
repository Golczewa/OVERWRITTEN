extends Area2D

@onready var player=get_tree().get_first_node_in_group("player")
@onready var henry=$CharacterBody2D

func _ready() -> void:
	henry.in_cutscene=true
	body_entered.connect(play_cuscene)

func play_cuscene(body:Node):
	if body!=player:
		return
	player.in_cutscene=true
	get_parent().door.disable_doors()
	$CollisionShape2D.set_deferred("disabled", true)
	player.focus_camera(henry.global_position)
	var tween=create_tween()
	tween.tween_property(henry,"rotation_degrees",90,2)
	await tween.finished
	await henry.boss_bar.boss_is_in("Henry",henry.test_max_health)
	player.retrun_camera()
	player.in_cutscene=false
	var henry_pos=henry.global_position
	remove_child(henry)
	get_parent().add_child(henry)
	henry.global_position=henry_pos
	get_parent().enemies+=1
	henry.in_cutscene=false


	