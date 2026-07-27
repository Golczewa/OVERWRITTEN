extends Node2D
var enemies: int = 0
var spawn: Vector2
var exit: Vector2
var cleard: bool = true

func _ready() -> void:
	spawn = $Marker2D2.global_position
	exit = $Area2D/Marker2D.global_position

## Instantly kills every enemy on this floor.
func kill_all() -> void:
	var enemies_: Array[Node] = $enemies.get_children()
	for enemy: Node in enemies_:
		enemy.take_damage(99999, 0)
