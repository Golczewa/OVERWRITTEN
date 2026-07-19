extends Area2D

var floor_
var level_;
var check=true
@onready var player = get_tree().get_first_node_in_group("player")
@onready var marker=$Marker2D

func _ready() -> void:
	$StaticBody2D/AnimatedSprite2D.play("closed")
	body_entered.connect(on_body_enterd)
	floor_ = get_parent()
	level_=floor_.get_parent()

func on_body_enterd(body):
	if body.is_in_group("player") and floor_.enemies==0:
		$StaticBody2D/PointLight2D.enabled=false
		move_on()
		$StaticBody2D/PointLight2D.enabled=true

func move_on():
	$StaticBody2D/AnimatedSprite2D.play("default")
	player.freeze_player()
	await $StaticBody2D/AnimatedSprite2D.animation_finished
	player.unfreeze_player()
	$StaticBody2D/AnimatedSprite2D.frame=0
	level_.call_deferred("move_up")

func _physics_process(_delta: float) -> void:
	if check:
		if not floor_.cleard:
			$StaticBody2D/AnimatedSprite2D.play("closed")
			$StaticBody2D/PointLight2D.color=Color.RED
		else:
			$StaticBody2D/AnimatedSprite2D.play("open")
			$StaticBody2D/PointLight2D.color=Color(0.067,0.658,0.07)
			check=false
	
