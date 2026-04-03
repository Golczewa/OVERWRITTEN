extends CharacterBody2D

@export var test_max_health: int =100
var curr_health: int

signal died

func _ready() -> void:
		curr_health=test_max_health
		
func take_damage(damage: int):
	curr_health=curr_health-damage
	_damage_effect()
	if curr_health<=0:
		_die()

func  _die():
	emit_signal("died")
	queue_free()

func _damage_effect():
	modulate=Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate=Color.WHITE
