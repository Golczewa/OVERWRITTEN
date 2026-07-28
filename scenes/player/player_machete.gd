extends Area2D
@export var machete_dmg: int = 25
var owner_node: Node = null
var knockback: int = 500
var is_owned_by_player = false
@export var cooldown = 0.7
var can_attack: bool = true
var parent
@export var skin: String = "0"


func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func attack():
	if can_attack:
		play_animation()
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(machete_dmg, knockback)
		can_attack = false
		get_tree().create_timer(cooldown).timeout.connect(end_cd)


func end_cd():
	can_attack = true


func play_animation():
	$AnimatedSprite2D.play("0")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.frame = 0
