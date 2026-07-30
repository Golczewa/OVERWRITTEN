extends StaticBody2D

@export_enum("on", "off") var state: String = "off"
var on_cooldown := false
var trash_pack: PackedScene = preload("res://scenes/levels/props/trash_steelmill.tscn")


func _ready() -> void:
	$Timer.timeout.connect(end_cooldown)
	if state == "off":
		$PointLight2D.hide()
	else:
		$PointLight2D2.hide()
	$AnimatedSprite2D.play(state)


func _physics_process(_delta: float) -> void:
	if state == "on" and not on_cooldown:
		var trash: Node = trash_pack.instantiate()
		print($Marker2D2.global_position, $Marker2D.global_position)
		add_child(trash)
		trash.rotate(randf_range(0, 6.28))
		trash.travel_and_melt($Marker2D.global_position, $Marker2D2.global_position)
		on_cooldown = true
		$Timer.start()


func end_cooldown():
	on_cooldown = false
