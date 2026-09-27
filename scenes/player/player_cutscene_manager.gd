extends Node2D

@onready var player: CharacterBody2D = self.get_parent()
@onready var explosion_pack: PackedScene = preload("res://scenes/effects/rocket_explosion.tscn")
@onready var parts_pack: PackedScene = preload("res://scenes/player/player_parts.tscn")
var in_stopable_cutscene := false


func get_up_cutscene():
	show()
	get_parent().show()
	in_stopable_cutscene = true
	hide_player_stuff()
	$AnimatedSprite2D.look_at(Vector2.RIGHT)
	if in_stopable_cutscene:
		$AnimatedSprite2D.play("turn_on")
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
	if in_stopable_cutscene:
		await get_tree().create_timer(2).timeout
	if in_stopable_cutscene:
		AudioPlayer.play_game_sfx(AudioPlayer.startup)
		$AnimatedSprite2D.play("turn_on")
	await $AnimatedSprite2D.animation_finished
	if in_stopable_cutscene:
		await get_tree().create_timer(1.5).timeout
	if in_stopable_cutscene:
		$AnimatedSprite2D.play("get_up")
	await $AnimatedSprite2D.animation_finished
	show_player_stuff()
	in_stopable_cutscene = false


func dying(death_duration := 1.5):
	z_index = 1
	for enemy: CharacterBody2D in get_tree().get_nodes_in_group("enemies"):
		enemy.z_index = 2
	player.body.hide()
	show()
	var death_number: int = randi_range(0, 4)
	if death_number == 4:
		explode()
	else:
		if ConfigManager.player_config.get_value("state", "cloth", false):
			$AnimatedSprite2D.animation = "dead_but_dresed"
		else:
			$AnimatedSprite2D.animation = "dead"
		$AnimatedSprite2D.frame = death_number
	print(visible, $AnimatedSprite2D.frame, death_number)
	await get_tree().create_timer(death_duration).timeout
	z_index = 0


func hide_player_stuff():
	show()
	player.in_cutscene = true
	player.body.hide()
	player.canvas.hide()
	player.legs.hide()


func show_player_stuff():
	hide()
	player.in_cutscene = false
	player.body.show()
	player.canvas.show()
	player.legs.show()


func explode(explosion_time = 0.3, spread = 100):
	$AnimatedSprite2D.hide()
	var curr_floor: Floor = player.get_parent().curr_scene.real_curr_floor
	var explosion: Node2D = explosion_pack.instantiate()
	explosion.scale *= 3
	add_child(explosion)
	for i in range(5):
		var part = parts_pack.instantiate()
		part.frame = i
		part.rotate(randf_range(0, 3.14))
		part.modulate = Color(0.25, 0.25, 0.25)
		part.global_position = global_position
		curr_floor.add_child(part)
		var tween: Tween = create_tween()
		tween.tween_property(
			part,
			"global_position",
			global_position + Vector2(randf_range(-spread, spread), randf_range(-spread, spread)),
			explosion_time
		)


func stop_cutscene():
	hide()
	in_stopable_cutscene = false
	player.in_cutscene = false
	show_player_stuff()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_cuscene") and in_stopable_cutscene:
		stop_cutscene()
