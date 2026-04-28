extends Area2D

var floor_
var level_;
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	body_entered.connect(on_body_enterd)
	floor_ = get_parent()
	level_=floor_.get_parent()

func on_body_enterd(body):
	if body.is_in_group("player") and floor_.enemies==0:
		move_on()

func move_on():
	$StaticBody2D/AnimatedSprite2D.play("default")
	player.freeze_player()
	await $StaticBody2D/AnimatedSprite2D.animation_finished
	$StaticBody2D/AnimatedSprite2D.frame=0
	player.unfreeze_player()
	level_.call_deferred("move_down")
