extends Area2D
@export var machete_dmg: int =25
var owner_node:Node=null
var knockback:int=500
var is_owned_by_player=false
@export var cooldown=0.7
var can_attack:bool=true
func _ready() -> void:
	if(get_parent().get_parent().is_in_group("player")):
		is_owned_by_player=true
func attack():
	if can_attack:
		$AnimatedSprite2D.play_backwards("attack")
		var bodies=get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies") and is_owned_by_player:
				body.take_damage(machete_dmg,knockback)
			elif body.is_in_group("player") and not is_owned_by_player:
				body.player_take_dmg(machete_dmg)
		can_attack=false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		
func end_cd():
	can_attack=true
