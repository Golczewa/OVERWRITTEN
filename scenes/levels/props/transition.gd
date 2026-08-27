extends Area2D

var floor_
var level_
var check = true
@onready var player = get_tree().get_first_node_in_group("player")
@onready var marker = $Marker2D
@onready var warning_window_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
signal close


func _ready() -> void:
	$StaticBody2D/AnimatedSprite2D.play("closed")
	body_entered.connect(on_body_enterd)
	floor_ = get_parent()
	level_ = floor_.get_parent()


func on_body_enterd(body):
	if body.is_in_group("player") and floor_.cleared:
		$StaticBody2D/PointLight2D.enabled = false
		move_on()
		$StaticBody2D/PointLight2D.enabled = true


func move_on():
	$StaticBody2D/AnimatedSprite2D.play("default")
	player.freeze_player()
	await $StaticBody2D/AnimatedSprite2D.animation_finished
	player.unfreeze_player()
	$StaticBody2D/AnimatedSprite2D.frame = 0
	close.emit()
	level_.call_deferred("move_up")


func _physics_process(_delta: float) -> void:
	if check:
		if not floor_.cleared:
			$StaticBody2D/AnimatedSprite2D.play("closed")
			$StaticBody2D/PointLight2D.color = Color.RED
		else:
			$StaticBody2D/AnimatedSprite2D.play("open")
			$StaticBody2D/PointLight2D.color = Color(0.067, 0.658, 0.07)
			spanw_warning()
			check = false


func spanw_warning():
	var warning_window = warning_window_pack.instantiate()
	player.canvas.add_child(warning_window)
	warning_window.setup(self, Vector2(74, 74), close, "Open doors")
