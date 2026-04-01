extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO,SPEED)
	move_and_slide()
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index==MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#$AnimatedSprite2D2.play_backwards("attack")
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_LEFT:
			if event.pressed:
				$Area2D/AnimatedSprite2D.play_backwards("attack")
