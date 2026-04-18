extends Area2D
@export var machete_dmg: int =25
var owner_node:Node=null
var knockback:int=500
var is_owned_by_player=false
@export var cooldown=0.7
var can_attack:bool=true
var parent

func _ready() -> void:
	$AnimatedSprite2D.frame=0
	parent=get_parent().get_parent()
	if(parent.is_in_group("player")):
		$AnimatedSprite2D.play("player_attack")
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame=0
		is_owned_by_player=true
func attack():
	if can_attack:
		play_animation()
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

func play_animation():
	if is_owned_by_player:
		$AnimatedSprite2D.play("player_attack")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play_backwards("player_attack")
	else:
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play_backwards("attack")
