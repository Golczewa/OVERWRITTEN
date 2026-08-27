extends Area2D
var floor_
var level_
var check: bool = true
var window: bool = false
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var marker = $Marker2D
@onready var warning_window_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
signal close


func _ready() -> void:
	$StaticBody2D/PointLight2D.show()
	body_entered.connect(on_body_enterd)
	floor_ = get_parent()
	level_ = floor_.get_parent()


func on_body_enterd(body):
	if body.is_in_group("player") and floor_.cleared:
		$CollisionShape2D.set_deferred("disabled", true)
		exit()


func exit():
	$StaticBody2D/AnimatedSprite2D.play("default")
	$StaticBody2D/PointLight2D.hide()
	await player.exit_anim($Marker2D.global_position, global_position)
	player.global_position = Vector2.ZERO
	player.clear_stray_warnings()
	level_.end_level()


func _physics_process(_delta: float) -> void:
	if not floor_.cleared:
		$StaticBody2D/AnimatedSprite2D.play("closed")
		$StaticBody2D/PointLight2D.hide()
		close.emit()
		window = false
	else:
		$StaticBody2D/AnimatedSprite2D.play("open")
		$StaticBody2D/PointLight2D.show()
		if not window:
			spanw_warning()
			window = true


func spanw_warning():
	var warning_window = warning_window_pack.instantiate()
	player.canvas.add_child(warning_window)
	warning_window.setup(self, Vector2(74, 74), close, "Exit!")
