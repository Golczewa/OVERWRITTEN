extends CharacterBody2D


var SPEED = 500.0
var dash=900
var player_health=100
var direction=Vector2.ZERO
var is_dashing:bool=false
var dash_cd:int=1
var can_dash:bool=true
var heal_amount=60
var heal_charge=3
var in_cutscene:bool=false
@export var heal_cd=30
@onready var legs=$AnimatedSprite2D2
@onready var heath_bar=$Camera2D/CanvasLayer/Control2/TextureProgressBar
@onready var charges=$Camera2D/CanvasLayer/Control
@onready var canvas=$Camera2D/CanvasLayer
@onready var hurt_pack=preload("res://scenes/player/hurt_efect.tscn")
@onready var heal_pack=preload("res://scenes/player/heal_efect.tscn")
var left_weapon
var right_weapon
var left_up_weapon
var right_up_weapon
signal player_died

var invincible:bool=false
var invisible:bool=false
var kill_swich:bool=false
var floor_jumping:bool=false

var default_state={
		"health": 100,
		"charges": 3,
		"replenish_queue": 0,
		"can_dash": true,
		"cd":0
	}
var charges_to_replenish: int = 0
var ghost= preload("res://scenes/player/player_ghost2.tscn")
var score

func _ready() -> void:
	score=get_parent().gameScore
	$Camera2D/CanvasLayer.hide()
	charges.update_max(heal_cd)
	charge_update()
	charges.value=heal_cd
	hp_update()
	charge_update()
	$Timer.timeout.connect(replenish_charge)
	heath_bar.max_value=player_health
	

func _physics_process(_delta: float) -> void:
	if not in_cutscene:
		$AnimatedSprite2D.look_at(get_global_mouse_position())
		if not is_dashing:
			direction = Input.get_vector("move_left","move_right","move_up","move_down")
			if direction:
				velocity = direction * SPEED
				legs.walk(velocity)
			else:
				velocity = velocity.move_toward(Vector2.ZERO,SPEED)
				legs.stop()
		move_and_slide()
	
func _process(_delta: float) -> void:
	if $Timer.time_left>0 and heal_charge!=3 and not in_cutscene:
		charges.update_value(heal_cd- $Timer.time_left)
	else:
		charges.update_value(heal_cd)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not in_cutscene:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				right_weapon.attack()
		elif event.button_index==MOUSE_BUTTON_RIGHT:
			if event.pressed:
				left_weapon.attack()
	elif event is InputEventKey:
		if event.keycode==KEY_SHIFT and event.pressed:
			_dash()
		elif  event.keycode==KEY_F and event.pressed:
			heal()
		elif event.keycode==KEY_QUOTELEFT and event.pressed:
			get_parent().open_cheats()
		elif event.keycode==KEY_K and event.pressed and kill_swich:
			get_parent().kill_all()

func player_take_dmg(dmg):
	if invincible:
		return
	if not is_dashing or not in_cutscene:
		player_health=player_health-dmg
		hp_update()
		if(player_health<=0):
			player_died.emit()
			score["deaths"]=score["deaths"]+1
		_damage_effect()
	
		
func _damage_effect():
	var hurt=hurt_pack.instantiate()
	canvas.add_child(hurt)

func _dash():
	if can_dash and not in_cutscene:
		var temp=SPEED
		var dash_dir=direction
		is_dashing=true
		add_ghost()
		set_collision_mask_value(3, false)
		set_collision_layer_value(1,false)
		if(dash_dir==Vector2.ZERO ):
			direction=Vector2(get_global_mouse_position()- global_position).normalized()
		velocity = direction * dash
		SPEED=dash
		add_ghost()
		await get_tree().create_timer(0.2).timeout
		SPEED=temp
		is_dashing=false
		can_dash=false
		set_collision_mask_value(3, true)
		set_collision_layer_value(1,true)
		get_tree().create_timer(dash_cd).timeout.connect(dash_again.bind())

func dash_again():
	can_dash=true

func heal():
	if heal_charge>0:
		if player_health+heal_amount>100:
			player_health=100
		else :
			player_health=player_health+heal_amount
		hp_update()
		score["hused"]=score["hused"]+1
		heal_charge=heal_charge-1
		charges_to_replenish += 1
		charge_update()
		heal_effect()
		if $Timer.is_stopped() and heal_charge<3:
			$Timer.start(heal_cd)

func hp_update():
	heath_bar.value=player_health

func charge_update():
	charges.update_charge(str(heal_charge))

func replenish_charge():
	if  charges_to_replenish > 0:
		heal_charge += 1
		charges_to_replenish -= 1 
		charge_update()
		charges.value=heal_cd
		if charges_to_replenish > 0 and heal_charge<3:
			$Timer.start(heal_cd)

func set_player_position(pos):
	$Camera2D/CanvasLayer.show()
	global_position=pos

func heal_effect():
	var heal_eff=heal_pack.instantiate()
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
	player_health = state["health"]
	heal_charge = state["charges"]
	charges_to_replenish = state["replenish_queue"]
	can_dash = state["can_dash"]
	if charges_to_replenish > 0:
		$Timer.start(state["cd"])
	is_dashing = false
	SPEED = 500.0
	set_collision_mask_value(3, true)
	set_collision_layer_value(1, true)
	unfreeze_player()
	hp_update()
	charge_update()
	var title=get_tree().get_first_node_in_group("title")
	if title != null:
		title.queue_free()
	
func add_ghost():
	while is_dashing:
		var ghost_inst=ghost.instantiate()
		ghost_inst.global_position=global_position
		ghost_inst.look_at(get_global_mouse_position())
		get_tree().current_scene.add_child(ghost_inst)
		await get_tree().create_timer(0.01).timeout
	
func equip_weapons():
	right_weapon=$AnimatedSprite2D/righthand.equip()
	left_weapon=$AnimatedSprite2D/lefthand.equip()
	
func exit_anim(pos_a:Vector2,pos_b:Vector2):
	in_cutscene=true
	var tween=create_tween().set_parallel(true)
	global_position=pos_a
	$AnimatedSprite2D.look_at(pos_b)
	tween.tween_property(self,"global_position",pos_b,1)
	tween.tween_property(self,"modulate",Color.BLACK,1)
	await tween.finished
	modulate=Color.WHITE
	in_cutscene=false

func clear_cheats():
	invincible=false
	invisible=false
	kill_swich=false
	show()

func make_invincible():
	invincible=!invincible
	score["cheats"]=true
	print(invincible)

func make_invisible():
	invisible=!invisible
	visible=!visible
	score["cheats"]=true
	print(invisible)

func enable_killswich():
	kill_swich=!kill_swich
	score["cheats"]=true
	print(kill_swich)

func enable_floor_jumping():
	score["cheats"]=true
