extends Area2D

var floor

func _ready() -> void:
	body_entered.connect(on_body_enterd)
	floor = get_parent()


func _process(delta: float) -> void:
	pass

func on_body_enterd(body):
	if body.is_in_group("player") and floor.enemies==0:
		move_on()

func move_on():
	pass
