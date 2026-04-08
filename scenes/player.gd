extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
var player_health=100

func _physics_process(_delta: float) -> void:
	$AnimatedSprite2D.look_at(get_global_mouse_position())
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
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

func player_take_dmg(dmg):
	player_health=player_health-dmg
	if(player_health<=0):
		get_tree().reload_current_scene()
