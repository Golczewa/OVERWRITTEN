extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var henry = $CharacterBody2D


func _ready() -> void:
	henry.toogle_cutscene()
	body_entered.connect(play_cuscene)


func play_cuscene(body: Node):
	if body != player:
		return
	AudioPlayer.volume_down()
	player.in_cutscene = true
	get_parent().door.disable_doors()
	$CollisionShape2D.set_deferred("disabled", true)
	player.focus_camera(henry.global_position)
	var tween = create_tween()
	tween.tween_property(henry, "rotation_degrees", 90, 2)
	await tween.finished
	henry.legs.stop_walking()
	await henry.boss_bar.boss_is_in("Henry - Scavenger lieutenant", henry.test_max_health)
	player.retrun_camera()
	player.in_cutscene = false
	var henry_pos = henry.global_position
	remove_child(henry)
	get_parent().add_enemy(henry, henry_pos)
	henry.toogle_cutscene()
	AudioPlayer.volume_up()
