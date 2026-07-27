extends Area2D
var damage: int = 10
var knockback: int = 200
var cooldown: float = 0.25
var can_attack: bool = true

func _ready() -> void:
	$AnimatedSprite2D.frame=0

## Performs a punch against overlapping enemies.
func attack() -> void:
	if can_attack:
		can_attack=false
		var bodies: Array[Node2D] = get_overlapping_bodies()
		$AnimatedSprite2D.play("default")
		for body: Node2D in bodies:
			if body.is_in_group("enemies"):
				body.take_damage(damage,knockback)
		await  $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.frame=0
		get_tree().create_timer(cooldown).timeout.connect(end_cd)

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())

func end_cd() -> void:
	can_attack=true
