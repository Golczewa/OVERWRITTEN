extends CharacterBody2D

var SPEED = 500.0
var dash = 900
var max_health = 150
var player_health = 150
var direction = Vector2.ZERO
var is_dashing: bool = false
var dash_cd: float = 1.5
var can_dash: bool = true
var heal_amount = 80
var heal_charge = 3
var in_cutscene: bool = false
@export var heal_cd = 30
@export var animation_manager: Node2D
@onready var legs = $AnimatedSprite2D2
@onready var heath_bar = $Camera2D/CanvasLayer/Control2/TextureProgressBar
@onready var charges = $Camera2D/CanvasLayer/Control
@onready var canvas = $Camera2D/CanvasLayer
@onready var camera: Camera2D = $Camera2D
@onready var body: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_pack: PackedScene = preload("res://scenes/player/hurt_efect.tscn")
@onready var heal_pack: PackedScene = preload("res://scenes/player/heal_efect.tscn")
var left_weapon
var right_weapon
var left_up_weapon
var right_up_weapon
signal player_died

var invincible: bool = false
var invisible: bool = false
var kill_swich: bool = false
var floor_jumping: bool = false
var in_menu: bool = false
var camera_fallow: Node2D

var default_state = {
	"health": max_health, "charges": 3, "replenish_queue": 0, "can_dash": true, "cd": 0
}
var charges_to_replenish: int = 0
var ghost = preload("res://scenes/player/player_ghost2.tscn")
var score
var camera_tween:Tween

func _ready() -> void:
	get_dresed()
	score = get_parent().gameScore
	$Camera2D/CanvasLayer.hide()
	charges.update_max(heal_cd)
	charges.update_dash_max(dash_cd)
	charge_update()
	hp_update()
	charge_update()
	$Timer.timeout.connect(replenish_charge)
	$dashTimer.timeout.connect(dash_again)
	heath_bar.max_value = max_health


func _physics_process(_delta: float) -> void:
	if not in_cutscene:
		$AnimatedSprite2D.look_at(get_global_mouse_position())
		if not is_dashing:
			direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			if direction:
				velocity = direction * SPEED
				legs.walk(velocity)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, SPEED)
				legs.stop()
		move_and_slide()
	else:
		if camera_fallow:
			$Camera2D.global_position = camera_fallow.global_position


func _process(_delta: float) -> void:
	if $Timer.time_left > 0 and heal_charge != 3 and not in_cutscene:
		charges.update_value(heal_cd - $Timer.time_left)
	else:
		charges.update_value(heal_cd)
	if !is_dashing:
		charges.update_dash(dash_cd - $dashTimer.time_left)
	else:
		charges.update_dash(0)
	if not in_cutscene and not in_menu:
		if Input.is_action_just_pressed("attack_left"):
			if left_weapon:
				left_weapon.attack("attack_left")
		if Input.is_action_just_pressed("attack_right"):
			if right_weapon:
				right_weapon.attack("attack_right")
		if Input.is_action_just_pressed("attack_left_up"):
			if left_up_weapon:
				left_up_weapon.attack("attack_left_up")
		if Input.is_action_just_pressed("attack_right_up"):
			if right_up_weapon:
				right_up_weapon.attack("attack_right_up")
		if Input.is_action_just_pressed("dash"):
			_dash()
		if Input.is_action_just_pressed("heal") and not in_cutscene:
			heal()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_QUOTELEFT and event.pressed:
			get_parent().open_cheats()
		elif event.keycode == KEY_K and event.pressed and kill_swich:
			get_parent().kill_all()


func player_take_dmg(dmg):
	if invincible or in_cutscene:
		return
	if not is_dashing:
		player_health = player_health - dmg
		hp_update()
		if player_health <= 0:
			die()
		else:
			AudioPlayer.play_game_sfx(AudioPlayer.get("hurt_" + str(randi_range(1, 4))))
			_damage_effect()


func die():
	in_cutscene = true
	invisible = true
	hide_stuff()
	modulate = Color(0.25, 0.25, 0.25)
	z_index = 1
	AudioPlayer.death_pause()
	await animation_manager.dying()
	in_cutscene = false
	player_died.emit()
	score["deaths"] = score["deaths"] + 1


func _damage_effect():
	var hurt = hurt_pack.instantiate()
	canvas.add_child(hurt)


func _dash():
	if can_dash and not in_cutscene:
		AudioPlayer.play_game_sfx(AudioPlayer.dash)
		var temp = SPEED
		var dash_dir = direction
		is_dashing = true
		charges.update_dash(0)
		add_ghost()
		set_collision_mask_value(3, false)
		set_collision_layer_value(1, false)
		if dash_dir == Vector2.ZERO:
			direction = Vector2(get_global_mouse_position() - global_position).normalized()
		velocity = direction * dash
		SPEED = dash
		add_ghost()
		await get_tree().create_timer(0.2).timeout
		SPEED = temp
		is_dashing = false
		can_dash = false
		set_collision_mask_value(3, true)
		set_collision_layer_value(1, true)
		$dashTimer.start(dash_cd)


func dash_again():
	can_dash = true


func heal():
	if heal_charge > 0:
		AudioPlayer.play_game_sfx(AudioPlayer.heal)
		if player_health + heal_amount > max_health:
			player_health = max_health
		else:
			player_health = player_health + heal_amount
		hp_update()
		score["hused"] = score["hused"] + 1
		heal_charge = heal_charge - 1
		charges_to_replenish += 1
		charge_update()
		heal_effect()
		if $Timer.is_stopped() and heal_charge < 3:
			$Timer.start(heal_cd)


func hp_update():
	heath_bar.value = player_health


func charge_update():
	charges.update_charge(heal_charge)


func replenish_charge():
	if charges_to_replenish > 0:
		heal_charge += 1
		charges_to_replenish -= 1
		charge_update()
		if charges_to_replenish > 0 and heal_charge < 3:
			$Timer.start(heal_cd)


func set_player_position(pos):
	$Camera2D/CanvasLayer.show()
	global_position = pos


func heal_effect():
	var heal_eff = heal_pack.instantiate()
	canvas.add_child(heal_eff)


func freeze_player():
	process_mode = Node.PROCESS_MODE_DISABLED


func unfreeze_player():
	process_mode = Node.PROCESS_MODE_INHERIT


func get_state() -> Dictionary:
	return {
		"health": player_health,
		"charges": heal_charge,
		"replenish_queue": charges_to_replenish,
		"can_dash": can_dash,
		"cd": $Timer.time_left
	}


func load_state(state: Dictionary):
	$Timer.stop()
	$AnimatedSprite2D.show()
	$Node2D.hide()
	show()
	get_dresed()
	AudioPlayer.stop_all_sfx()
	player_health = state["health"]
	heal_charge = state["charges"]
	charges_to_replenish = state["replenish_queue"]
	can_dash = state["can_dash"]
	if charges_to_replenish > 0:
		$Timer.start(state["cd"])
	invisible = false
	is_dashing = false
	SPEED = 500.0
	modulate = Color.WHITE
	z_index = 3
	show_stuff()
	set_collision_mask_value(3, true)
	set_collision_layer_value(1, true)
	unfreeze_player()
	hp_update()
	charge_update()
	$Camera2D/CanvasLayer/ProgressBar2.modulate.a = 0
	var title = get_tree().get_first_node_in_group("title")
	if title != null:
		title.queue_free()
	clear_stray_warnings()


func add_ghost():
	while is_dashing:
		var ghost_inst = ghost.instantiate()
		ghost_inst.global_position = global_position
		ghost_inst.look_at(get_global_mouse_position())
		get_tree().current_scene.add_child(ghost_inst)
		await get_tree().create_timer(0.01).timeout


func equip_weapons():
	right_weapon = $AnimatedSprite2D/righthand.equip()
	left_weapon = $AnimatedSprite2D/lefthand.equip()
	left_up_weapon = $AnimatedSprite2D/leftuphand.equip()
	right_up_weapon = $AnimatedSprite2D/rightuphand.equip()


func exit_anim(pos_a: Vector2, pos_b: Vector2, anim_time: int = 1):
	in_cutscene = true
	var tween = create_tween().set_parallel(true)
	global_position = pos_a
	$AnimatedSprite2D.look_at(pos_b)
	legs.walk_anim(pos_b)
	tween.tween_property(self, "global_position", pos_b, anim_time)
	tween.tween_property(self, "modulate", Color.BLACK, anim_time)
	await tween.finished
	modulate = Color.WHITE
	legs.stop_walking()
	in_cutscene = false


func entrance_anim(pos_a: Vector2, pos_b: Vector2, anim_time: int = 1):
	in_cutscene = true
	global_position = pos_a
	var tween = create_tween().set_parallel(true)
	$AnimatedSprite2D.look_at(pos_b)
	legs.walk_anim(pos_b)
	modulate = Color.BLACK
	tween.tween_property(self, "global_position", pos_b, anim_time)
	tween.tween_property(self, "modulate", Color.WHITE, anim_time)
	await tween.finished
	legs.stop_walking()
	in_cutscene = false


func clear_cheats():
	invincible = false
	invisible = false
	kill_swich = false
	show()


func make_invincible():
	invincible = !invincible
	score["cheats"] = true


func make_invisible():
	invisible = !invisible
	visible = !visible
	score["cheats"] = true


func enable_killswich():
	kill_swich = !kill_swich
	score["cheats"] = true


func enable_floor_jumping():
	score["cheats"] = true


func focus_camera(pos: Vector2, travel_time = 1):
	camera_tween = create_tween()
	camera_tween.tween_property($Camera2D, "global_position", pos, travel_time)
	await camera_tween.finished


func set_camera_fallow(who: Node2D):
	camera_fallow = who


func retrun_camera():
	camera_fallow = null
	if camera_tween:
		camera_tween.kill()
	$Camera2D.global_position = global_position


func hide_stuff():
	for weapon in $AnimatedSprite2D.get_children():
		weapon.hide()
	$AnimatedSprite2D2.hide()


func show_stuff():
	for weapon in $AnimatedSprite2D.get_children():
		weapon.show()
	$AnimatedSprite2D2.show()


func clear_stray_warnings():
	$Camera2D/CanvasLayer/MenuWindow.begone()
	for child: Control in canvas.get_children():
		if child.z_index == -123:
			child.queue_free()


func get_dresed():
	var cloth: bool = ConfigManager.player_config.get_value("state", "cloth", false)
	if cloth:
		body.frame = 1
	else:
		body.frame = 0
