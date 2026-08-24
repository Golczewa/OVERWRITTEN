extends CharacterBody2D

var SPEED = 500.0
var dash = 900
var max_health = 150
var player_health = 150
var direction = Vector2.ZERO
var is_dashing: bool = false
var dash_cd: int = 1
var can_dash: bool = true
var heal_amount = 80
var heal_charge = 3
var in_cutscene: bool = false
@export var heal_cd = 30
@onready var legs = $AnimatedSprite2D2
@onready var heath_bar = $Camera2D/CanvasLayer/Control2/TextureProgressBar
@onready var charges = $Camera2D/CanvasLayer/Control
@onready var canvas = $Camera2D/CanvasLayer
@onready var camera: Camera2D = $Camera2D
@onready var hurt_pack: PackedScene = preload("res://scenes/player/hurt_efect.tscn")
@onready var heal_pack: PackedScene = preload("res://scenes/player/heal_efect.tscn")
@onready var parts_pack: PackedScene = preload("res://scenes/player/player_parts.tscn")
@onready var explosion_pack: PackedScene = preload("res://scenes/effects/rocket_explosion.tscn")
var left_weapon
var right_weapon
var left_up_weapon
var right_up_weapon
signal player_died

var invincible: bool = false
var invisible: bool = false
var kill_swich: bool = false
var floor_jumping: bool = false
var camera_fallow: Node2D

var default_state = {
	"health": max_health, "charges": 3, "replenish_queue": 0, "can_dash": true, "cd": 0
}
var charges_to_replenish: int = 0
var ghost = preload("res://scenes/player/player_ghost2.tscn")
var score


func _ready() -> void:
	score = get_parent().gameScore
	$Camera2D/CanvasLayer.hide()
	charges.update_max(heal_cd)
	charge_update()
	hp_update()
	charge_update()
	$Timer.timeout.connect(replenish_charge)
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


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT and event.pressed:
			_dash()
		elif event.keycode == KEY_F and event.pressed:
			heal()
		elif event.keycode == KEY_QUOTELEFT and event.pressed:
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
			_damage_effect()


func die(death_duration := 1.5):
	in_cutscene = true
	invisible = true
	hide_stuff()
	modulate = Color(0.25, 0.25, 0.25)
	z_index = 1
	var death_number: int = randi_range(0, 4)
	if death_number == 4:
		explode()
	else:
		$AnimatedSprite2D.play("dead")
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = death_number
	await get_tree().create_timer(death_duration).timeout
	in_cutscene = false
	player_died.emit()
	score["deaths"] = score["deaths"] + 1


func _damage_effect():
	var hurt = hurt_pack.instantiate()
	canvas.add_child(hurt)


func _dash():
	if can_dash and not in_cutscene:
		var temp = SPEED
		var dash_dir = direction
		is_dashing = true
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
		get_tree().create_timer(dash_cd).timeout.connect(dash_again.bind())


func dash_again():
	can_dash = true


func heal():
	if heal_charge > 0:
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
	show()
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
	$AnimatedSprite2D.play("new_animation")
	set_collision_mask_value(3, true)
	set_collision_layer_value(1, true)
	unfreeze_player()
	hp_update()
	charge_update()
	$Camera2D/CanvasLayer/ProgressBar2.modulate.a = 0
	var title = get_tree().get_first_node_in_group("title")
	if title != null:
		title.queue_free()


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
	var tween = create_tween()
	tween.tween_property($Camera2D, "global_position", pos, travel_time)
	await tween.finished


func set_camera_fallow(who: Node2D):
	camera_fallow = who


func retrun_camera():
	camera_fallow = null
	$Camera2D.global_position = global_position


func hide_stuff():
	for weapon in $AnimatedSprite2D.get_children():
		weapon.hide()
	$AnimatedSprite2D2.hide()


func show_stuff():
	for weapon in $AnimatedSprite2D.get_children():
		weapon.show()
	$AnimatedSprite2D2.show()


func explode(explosion_time = 0.3, spread = 100):
	$AnimatedSprite2D.hide()
	var curr_floor: Floor = get_parent().curr_scene.real_curr_floor
	var explosion: Node = explosion_pack.instantiate()
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
