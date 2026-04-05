extends Area2D
var speed: int =400
var perce: int=1
var perced:int=0
var dmg: int =20
var velocity 
var second_pos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_enterd)
	var direction = (global_position-second_pos).normalized()
	velocity = direction * speed
func _on_body_enterd(body):
	if body.is_in_group("enemies"):
		body.take_damage(dmg)
		perced=perced+1
		if perced==1:
			queue_free()
	else:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position=position + velocity*delta
