extends Area2D
@export var machete_dmg: int =25
var owner_node: Node = null
var knockback: int =500
var is_owned_by_player: bool = false
@export var cooldown: float = 0.7
var can_attack: bool = true
var parent: Node
@export var skin: String = "0"

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

## Performs a melee swing and damages overlapping enemies.
func attack() -> void:
	if can_attack:
		play_animation()
		var bodies: Array[Node2D] = get_overlapping_bodies()
		for body: Node2D in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(machete_dmg,knockback)
		can_attack=false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)
		
func end_cd() -> void:
	can_attack=true

func play_animation() -> void:
	$AnimatedSprite2D.play("0")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.frame=0
	
