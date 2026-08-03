extends Area2D
var player
var menu_pack = preload("res://scenes/menu/post_menu.tscn")
var menu
var floor_


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	floor_ = get_parent().get_parent()
	body_entered.connect(show_menu)
	body_exited.connect(hide_menu)


func show_menu(body):
	if body == player and floor_.cleared:
		menu = menu_pack.instantiate()
		player.canvas.add_child(menu)


func hide_menu(body):
	if body == player and floor_.cleared:
		if menu:
			menu.queue_free()


func _process(_delta: float) -> void:
	if floor_.cleared:
		$PointLight2D.enabled = true
	else:
		$PointLight2D.enabled = false
