extends Area2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var henry = $CharacterBody2D
var tween: Tween
var stop: bool = false


func _ready() -> void:
	#get_parent().get_parent().restart.connect(stop_cutscene)
	henry.toogle_cutscene()
	body_entered.connect(play_cuscene)


func play_cuscene(body: Node):
	print("cutscene")
	if body != player:
		return
	AudioPlayer.volume_down()
	player.in_cutscene = true
	get_parent().door.disable_doors()
	$CollisionShape2D.set_deferred("disabled", true)
	player.focus_camera(henry.global_position)
	tween = create_tween()
	tween.tween_property(henry, "rotation_degrees", 90, 2)
	if stop:
		print("stoped1")
		return
	await tween.finished
	henry.legs.stop_walking()
	if stop:
		print("stoped2")
		return
	await henry.boss_bar.boss_is_in("Henry - Scavenger lieutenant", henry.max_health)
	if stop:
		print("stoped3")
		return
	player.retrun_camera()
	player.in_cutscene = false
	var henry_pos = henry.global_position
	remove_child(henry)
	get_parent().add_enemy(henry, henry_pos)
	henry.toogle_cutscene()
	AudioPlayer.volume_up()


func stop_cutscene():
	print("something happend")
	player.in_cutscene = false
	stop = true
	if tween:
		tween.kill()
	henry.boss_bar.stop_animation(henry.max_health)
	player.retrun_camera()
	AudioPlayer.volume_up()
