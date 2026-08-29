extends Node2D

var dance_tween: Tween
var check: bool = true
var messege: String
var window := false
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var curr_floor: Floor = get_parent()
@onready var tutorial_window_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
signal end_signal


func _ready() -> void:
	$Area2D.body_entered.connect(on_body_entered)


func _physics_process(_delta: float) -> void:
	if ConfigManager.player_config.get_value("state", "cloth", false):
		curr_floor.cutscenes -= 1
		queue_free()
	else:
		spawn_warning()
	if curr_floor.enemies_cleared and check:
		check = false
		dance()


func dance(size_offset: float = 0.15, time: float = 0.5) -> void:
	if dance_tween:
		dance_tween.kill()
	dance_tween = create_tween()
	dance_tween.set_loops()
	dance_tween.set_trans(Tween.TRANS_SINE)
	dance_tween.set_ease(Tween.EASE_IN_OUT)
	dance_tween.tween_property($AnimatedSprite2D, "scale", Vector2.ONE * (1 + size_offset), time)
	dance_tween.tween_property($AnimatedSprite2D, "scale", Vector2.ONE * (1 - size_offset), time)


func on_body_entered(body: Node2D) -> void:
	if body == player:
		if dance_tween:
			dance_tween.kill()
		ConfigManager.player_config.set_value("state", "cloth", true)
		ConfigManager.save_player_config()
		player.equip_weapons()
		player.get_dresed()
		curr_floor.cutscenes -= 1
		end_signal.emit()
		queue_free()


func spawn_warning():
	if window:
		return
	var tutorial_window = tutorial_window_pack.instantiate()
	player.canvas.add_child(tutorial_window)
	tutorial_window.setup(self, Vector2(64, 32), end_signal, "your coat")
	window = true
