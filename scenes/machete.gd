extends Area2D
@export var machete_dmg: int =35
var owner_node:Node=null
var something_in:bool=false
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func attack():
	$AnimatedSprite2D.play_backwards("attack")
	var bodies=get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.take_damage(machete_dmg)
		
