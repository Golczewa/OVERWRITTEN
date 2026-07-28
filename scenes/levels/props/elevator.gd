extends Area2D

var floor_
var level_
var check = true
@export_enum("up", "down") var dir = "up"
@onready var player = get_tree().get_first_node_in_group("player")
@onready var marker = $Marker2D


func _ready() -> void:
	body_entered.connect(move_on)
	$Area2D.body_entered.connect(open_doors)
	$Area2D.body_exited.connect(close_doors)
	floor_ = get_parent()
	level_ = floor_.get_parent()


func open_doors(body: Node2D):
	if body.is_in_group("player") and floor_.cleard:
		$StaticBody2D/StaticBody2D/PointLight2D.hide()
		$StaticBody2D/StaticBody2D/AnimatedSprite2D.play("default")
		$StaticBody2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)


func close_doors(body: Node2D):
	if body.is_in_group("player") and floor_.cleard:
		$StaticBody2D/StaticBody2D/AnimatedSprite2D.play_backwards("default")
		$StaticBody2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
		await $StaticBody2D/StaticBody2D/AnimatedSprite2D.animation_finished
		$StaticBody2D/StaticBody2D/PointLight2D.show()


func move_on(body: Node2D):
	if body.is_in_group("player") and floor_.cleard:
		$StaticBody2D/StaticBody2D/AnimatedSprite2D.play_backwards("default")
		player.freeze_player()
		await $StaticBody2D/StaticBody2D/AnimatedSprite2D.animation_finished
		player.unfreeze_player()
		if dir == "up":
			level_.call_deferred("move_up")
		else:
			level_.call_deferred("move_down")


func _physics_process(_delta: float) -> void:
	if check:
		if not floor_.cleard:
			$StaticBody2D/StaticBody2D/AnimatedSprite2D.play("closed")
			$StaticBody2D/StaticBody2D/PointLight2D.color = Color.RED
		else:
			$StaticBody2D/StaticBody2D/AnimatedSprite2D.play("open")
			$StaticBody2D/StaticBody2D/PointLight2D.color = Color(0.067, 0.658, 0.07)
			check = false
