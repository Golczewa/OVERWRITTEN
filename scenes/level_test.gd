extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var doors= get_tree().get_nodes_in_group("doors")
	for door in doors:
		var collision=door.get_node("StaticBody2D/CollisionShape2D")
		collision.set_deferred("disabled", true)
	#$Area2D2/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	#$Area2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().process_frame
	bake_navigation_polygon()
	for door in doors:
		var collision=door.get_node("StaticBody2D/CollisionShape2D")
		collision.set_deferred("disabled", false)
	#$Area2D2/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	#$Area2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
