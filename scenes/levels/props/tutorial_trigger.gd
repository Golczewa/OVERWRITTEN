extends Area2D

@export var text: String
@export var action_array: Array[String]
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var window: MenuWindow = player.get_node("Camera2D/CanvasLayer/MenuWindow")


func get_action_key_name(action: String) -> String:
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			var code = event.physical_keycode if event.physical_keycode != 0 else event.keycode
			return OS.get_keycode_string(code)
		elif event is InputEventMouseButton:
			return event.as_text()
	return "Unbound"


func format_text():
	for action in action_array:
		var index = text.find("[key]")
		if index != -1:
			text = text.substr(0, index) + get_action_key_name(action) + text.substr(index + 5)


func _ready() -> void:
	body_entered.connect(spawn_window)


func spawn_window(body: Node2D):
	if body == player:
		format_text()
		window.setup(text)
		queue_free()
