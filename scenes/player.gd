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
signal player_died

func _ready() -> void:
	hp_update()
	charge_update()

func _physics_process(_delta: float) -> void:
	$AnimatedSprite2D.look_at(get_global_mouse_position())
	if not is_dashing:
		direction = Input.get_vector("move_left","move_right","move_up","move_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity = velocity.move_toward(Vector2.ZERO,SPEED)
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				$AnimatedSprite2D/Area2D.attack()
		elif event.button_index==MOUSE_BUTTON_RIGHT:
			if event.pressed:
				$AnimatedSprite2D/AnimatedSprite2D2.attack()
	elif event is InputEventKey:
		if event.keycode==KEY_SHIFT and event.pressed:
			_dash()
		elif  event.keycode==KEY_F and event.pressed:
			heal()

func player_take_dmg(dmg):
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
		if(dash_dir==Vector2.ZERO ):
			direction=Vector2(get_global_mouse_position()- global_position).normalized()
		velocity = direction * dash
		SPEED=dash	
		await get_tree().create_timer(0.2).timeout
		SPEED=temp
		is_dashing=false
		can_dash=false
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
		charge_update()
		heal_effect()
		get_tree().create_timer(30).timeout.connect(replenish_charge.bind())

func hp_update():
	$Label.text = "HP: " + str(player_health)

func charge_update():
	$Label2.text=str(heal_charge)

func replenish_charge():
	heal_charge=heal_charge+1
	charge_update()

func set_player_position(pos):
	global_position=pos

func heal_effect():
	$AnimatedSprite2D.modulate=Color.WEB_GREEN
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate=Color.WHITE
	
func freeze_player():
	process_mode = Node.PROCESS_MODE_DISABLED 
	
func unfreeze_player():
	process_mode = Node.PROCESS_MODE_INHERIT
