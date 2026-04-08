extends Area2D
@export var machete_dmg: int =35
var owner_node:Node=null
@export var cooldown=0.5
var can_attack:bool=true

func attack():
	if can_attack:
		$AnimatedSprite2D.play_backwards("attack")
		var bodies=get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(machete_dmg)
		can_attack=false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		
func end_cd():
	can_attack=true
