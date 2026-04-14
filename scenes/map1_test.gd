extends NavigationRegion2D

var enemies
var enemies_number=0

func _ready() -> void:
	call_deferred("setup")

func  setup():
	var doors= get_tree().get_nodes_in_group("doors")
	for door in doors:
		var collision=door.get_node("StaticBody2D/CollisionShape2D")
		collision.set_deferred("disabled", true)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	bake_navigation_polygon()
	for door in doors:
		var collision=door.get_node("StaticBody2D/CollisionShape2D")
		collision.set_deferred("disabled", false)
