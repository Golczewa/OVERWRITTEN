extends AnimatedSprite2D

@export_enum("right", "left_upper", "right_upper") var hand: String = "right"

var dance_tween: Tween
var check: bool = true
var messege: String
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var curr_floor: Floor = get_parent()
@onready var tutorial_window_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
@onready var window: MenuWindow = player.get_node("Camera2D/CanvasLayer/MenuWindow")
signal end_signal


func _ready() -> void:
	if ConfigManager.player_config.get_value("hands", hand, true):
		curr_floor.cutscenes -= 1
		queue_free()
		return
	$Area2D.body_entered.connect(on_body_entered)
	if hand == "right":
		frame = 0
		messege = "Your hand!"
	else:
		frame = 1
		messege = "Compatible hand!"


func _physics_process(_delta: float) -> void:
	if curr_floor.enemies_cleared and check:
		check = false
		dance()


func dance(size_offset: float = 0.15, time: float = 0.5) -> void:
	var tutorial_window = tutorial_window_pack.instantiate()
	player.canvas.add_child(tutorial_window)
	tutorial_window.setup(self, Vector2(32, 32), end_signal, messege)
	if dance_tween:
		dance_tween.kill()
	dance_tween = create_tween()
	dance_tween.set_loops()
	dance_tween.set_trans(Tween.TRANS_SINE)
	dance_tween.set_ease(Tween.EASE_IN_OUT)
	dance_tween.tween_property(self, "scale", Vector2.ONE * (1 + size_offset), time)
	dance_tween.tween_property(self, "scale", Vector2.ONE * (1 - size_offset), time)


func on_body_entered(body: Node2D) -> void:
	if body == player:
		if dance_tween:
			dance_tween.kill()
		ConfigManager.player_config.set_value("hands", hand, true)
		ConfigManager.save_player_config()
		player.equip_weapons()
		curr_floor.cutscenes -= 1
		end_signal.emit()
		spawn_tutorial_window()
		queue_free()
		AudioPlayer.play_game_sfx(AudioPlayer.pickup_hand)


func spawn_tutorial_window():
	if hand == "right":
		var key = get_action_key_name("attack_right")
		window.setup("Press " + key + " to use weapon in your right hand")
	elif hand == "left_upper":
		var key = get_action_key_name("attack_left_up")
		window.setup("Press " + key + " to use weapon in your upper left hand")
	else:
		var key = get_action_key_name("attack_right_up")
		window.setup("Press " + key + " to use weapon in your upper right hand")


func get_action_key_name(action: String) -> String:
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			var code = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			return OS.get_keycode_string(code)
		elif event is InputEventMouseButton:
			return event.as_text()
	return "Unbound"
