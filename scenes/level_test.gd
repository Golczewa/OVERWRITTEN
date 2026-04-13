extends NavigationRegion2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D2/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	await get_tree().process_frame
	bake_navigation_polygon()
	$Area2D2/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	$Area2D/StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
