extends AnimatedSprite2D
@export var len=10

func makeTrail():
	for i in range(0,len):
		var ghost=duplicate()
		get_parent().add_child(ghost)
		ghost.markToVanish()

func markToVanish():
	visible=true
	await get_tree().create_timer(1)
	queue_free()
