extends Area2D

var damage = 40
var waiting_time = 2

@onready var explosion_pack: PackedScene = preload("res://scenes/effects/rocket_explosion.tscn")


func _ready() -> void:
	$Timer.timeout.connect(landing)
	$Timer.start(waiting_time)


func landing() -> void:
	var bodies_in = get_overlapping_bodies()
	for body in bodies_in:
		if body.is_in_group("player"):
			body.player_take_dmg(damage)
	spawn_exlosion()


func spawn_exlosion() -> void:
	var explosion: Node2D = explosion_pack.instantiate()
	explosion.global_position = global_position
	explosion.scale *= 2.5
	get_parent().add_child(explosion)
	queue_free()
