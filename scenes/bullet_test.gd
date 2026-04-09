extends Area2D
var speed: int =1500
var perce: int=1
var perced:int=0
var dmg: int =20
var velocity 
var direction

func _ready() -> void:
	body_entered.connect(_on_body_enterd)
	look_at(direction)
	velocity = direction * speed
	$RayCast2D.target_position = Vector2(speed * get_physics_process_delta_time(), 0)
func _on_body_enterd(body):
	if body.is_in_group("enemies"):
		body.take_damage(dmg,0)
		if perced==perce:
			queue_free()
		perced=perced+1
	else:
		queue_free()

func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if not collider.is_in_group("enemies"):
			queue_free()
	position=position + velocity*delta
