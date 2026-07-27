extends Node2D
var enemies: int = 0
var spawn: Vector2
var exit: Vector2
var cleard: bool = false
var enemy_spawner: Node

func _ready() -> void:
	spawn = $Area2D2/Marker2D.global_position
	exit = $Area2D/Marker2D.global_position

func _physics_process(_delta: float) -> void:
	if enemies == 0:
		cleard = true

## Instantly kills every enemy on this floor.
func kill_all() -> void:
	var enemies_: Array[Node] = $enemies.get_children()
	for enemy: Node in enemies_:
		enemy.take_damage(99999, 0)
