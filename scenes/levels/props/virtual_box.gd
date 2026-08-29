extends StaticBody2D

var floor_
var dead = false
@export var with_warning: bool = false
@onready var warning_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
signal died


func _ready() -> void:
	floor_ = get_parent().get_parent()
	floor_.enemies = floor_.enemies + 1
	if with_warning:
		var warning = warning_pack.instantiate()
		player.canvas.add_child(warning)
		warning.setup(self, Vector2(64, 64), died, "Enemy simulation")


func begone():
	floor_.enemies = floor_.enemies - 1
	$CollisionShape2D.set_deferred("disabled", true)
	$PointLight2D.hide()
	var tween = create_tween().set_parallel(true)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0, 0), 0.2)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.2)
	dead = true
	died.emit()


func take_damage(_damage: int, _knockback: int):
	if not dead:
		begone()
