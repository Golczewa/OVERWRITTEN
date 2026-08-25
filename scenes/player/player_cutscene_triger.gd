extends Area2D

@export var cutscene: String
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	body_entered.connect(trigger)


func trigger(body: Node2D):
	if body==player and cutscene:
		player.call(cutscene)
	$CollisionShape2D.set_deferred("disabled",true)