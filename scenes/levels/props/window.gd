extends StaticBody2D

var shard_pack: PackedScene = preload("res://scenes/effects/window_shard.tscn")
@onready var floor_: Floor = get_parent().get_parent()
var broken := false


func shatter(body: Node):
	if broken:
		return
	broken = true
	if body.is_in_group("bullets"):
		print("shattering now by", body)
		$AnimatedSprite2D.play("broken")
		var direction: Vector2 = body.direction
		direction = direction.normalized()
		for i in range(6):
			var random_pos = direction.rotated(randf_range(-0.78, 0.78)) * randf_range(20, 60)
			spawn_shard(global_position + random_pos)


func spawn_shard(end_pos: Vector2, time = 0.1):
	var tween := create_tween()
	var shard = shard_pack.instantiate()
	shard.frame = randi_range(0, 3)
	shard.global_position = global_position
	floor_.add_child(shard)
	tween.tween_property(shard, "global_position", end_pos, time)
