extends StaticBody2D

var on_cooldown := false
var trash_pack: PackedScene = preload("res://scenes/levels/props/trash_steelmill.tscn")
@onready var pos_a: Vector2 = $Marker2D.global_position
@onready var pos_b: Vector2 = $Marker2D2.global_position


func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$Timer.timeout.connect(end_cooldown)


func _physics_process(_delta: float) -> void:
	if not on_cooldown:
		for i in range(9):
			var trash: Node = trash_pack.instantiate()
			add_child(trash)
			trash.rotate(randf_range(0, 6.28))
			var offset = randf_range(-20, 20)
			var trash_pos = Vector2(randf_range(pos_a.x, pos_b.x), pos_a.y + offset)
			trash.travel_and_melt(
				trash_pos, Vector2(trash_pos.x, $Marker2D3.global_position.y + offset)
			)
		on_cooldown = true
		$Timer.start()


func end_cooldown():
	on_cooldown = false
