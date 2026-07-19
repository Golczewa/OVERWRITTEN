extends StaticBody2D
var floor_
var level_;
var check:bool=true
@onready var marker=$Marker2D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	$Area2D.body_entered.connect(on_body_enterd)
	floor_ = get_parent()
	level_=floor_.get_parent()

func on_body_enterd(body):
	if body.is_in_group("player"):
		enter(body)

func enter(body:CharacterBody2D):
	$AnimatedSprite2D.play("default")
	await body.entrance_anim($Marker2D.global_position,$Marker2D2.global_position)
	$CollisionShape2D.set_deferred("disabled", false)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play_backwards("default")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("closed")
