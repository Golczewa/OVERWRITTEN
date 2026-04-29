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
@export var heal_cd=30
@onready var legs=$AnimatedSprite2D2
@onready var heath_bar=$Camera2D/CanvasLayer/Label
@onready var charges=$Camera2D/CanvasLayer/ProgressBar
var left_weapon
var right_weapon
var left_up_weapon
var right_up_weapon
signal player_died
var default_state={
		"health": 100,
		"charges": 3,
		"replenish_queue": 0,
		"can_dash": true
	}
var charges_to_replenish: int = 0

func _ready() -> void:
	right_weapon=$AnimatedSprite2D/righthand.equip(1)
	left_weapon=$AnimatedSprite2D/lefthand.equip(0)
	right_up_weapon=$AnimatedSprite2D/rightuphand.equip(1)
	left_up_weapon=$AnimatedSprite2D/leftuphand.equip(1)
	$Camera2D/CanvasLayer.hide()
	charges.max_value=heal_cd
	charges.value=heal_cd
	hp_update()
	charge_update()
	$Timer.timeout.connect(replenish_charge)

func _physics_process(_delta: float) -> void:
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
	if $Timer.time_left>0 and heal_charge!=3:
		charges.value = $Timer.wait_time - $Timer.time_left
	else:
		charges.value=heal_cd

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				right_weapon.attack()
				right_up_weapon.attack()
		elif event.button_index==MOUSE_BUTTON_RIGHT:
			if event.pressed:
				left_weapon.attack()
				left_up_weapon.attack()
	elif event is InputEventKey:
		if event.keycode==KEY_SHIFT and event.pressed:
			_dash()
		elif  event.keycode==KEY_F and event.pressed:
			heal()

func player_take_dmg(dmg):
	if not is_dashing:
		player_health=player_health-dmg
		hp_update()
		if(player_health<=0):
			player_died.emit()
		_damage_effect()
	
		
func _damage_effect():
	$AnimatedSprite2D.modulate=Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate=Color.WHITE

func _dash():
	if can_dash:
		var temp=SPEED
		var dash_dir=direction
		is_dashing=true
		set_collision_mask_value(3, false)
		set_collision_layer_value(1,false)
		if(dash_dir==Vector2.ZERO ):
			direction=Vector2(get_global_mouse_position()- global_position).normalized()
		velocity = direction * dash
		SPEED=dash	
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
		heal_charge=heal_charge-1
		charges_to_replenish += 1
		charge_update()
		heal_effect()
		if $Timer.is_stopped() and heal_charge<3:
			$Timer.start(heal_cd)

func hp_update():
	heath_bar.text = "Integrity:\n" + str(player_health)+"%"

func charge_update():
	$Camera2D/CanvasLayer/ProgressBar/Label.text=str(heal_charge)

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
	$AnimatedSprite2D.modulate=Color.WEB_GREEN
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate=Color.WHITE
	
func freeze_player():
	process_mode = Node.PROCESS_MODE_DISABLED 
	
func unfreeze_player():
	process_mode = Node.PROCESS_MODE_INHERIT

func get_state() -> Dictionary:
	return {
		"health": player_health,
		"charges": heal_charge,
		"replenish_queue": charges_to_replenish,
		"can_dash": can_dash
	}
func load_state(state: Dictionary):
	$Timer.stop()
	player_health = state["health"]
	heal_charge = state["charges"]
	charges_to_replenish = state["replenish_queue"]
	can_dash = state["can_dash"]
	if charges_to_replenish > 0:
		$Timer.start(heal_cd)
	is_dashing = false
	SPEED = 500.0
	set_collision_mask_value(3, true)
	set_collision_layer_value(1, true)
	unfreeze_player()
	hp_update()
	charge_update()
