extends Area2D
@export var machete_dmg: int =25
var owner_node:Node=null
var knockback:int=500
var is_owned_by_player=false
@export var cooldown=0.7
var can_attack:bool=true
var parent
@export var skin:String="0"

func _ready() -> void:
	skin_(skin)

func skin_(num):
	$AnimatedSprite2D.play(num)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame=0
	if(num=="2"):
		$AnimatedSprite2D.position=Vector2(29,-13)

func attack():
	await get_tree().create_timer(0.1).timeout
	if can_attack:
		play_animation(skin)
		var bodies=get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("player"):
				body.player_take_dmg(machete_dmg)
		can_attack=false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		
func end_cd():
	can_attack=true

func play_animation(num):
	$AnimatedSprite2D.play(num)
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.frame=0
	
