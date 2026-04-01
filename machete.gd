extends Area2D

signal hit_enemy(enemy,dmg)

@export var machete_dmg: int =35
var owner_node:Node=null
var monitor: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitor=true
func enable():
	monitoring = true

func disable():
	monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
