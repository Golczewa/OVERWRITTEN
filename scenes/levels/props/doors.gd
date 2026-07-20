extends Area2D
@export var locked:bool=false
@export_enum("steelmill1","steelmill2") var skin:String="steemill1"

const skin_num={
	"steelmill1"=0,
	"steelmill2"=1

}

func _ready() -> void:
	body_entered.connect(on_body_enterd)
	body_exited.connect(on_body_exited)
	$StaticBody2D/AnimatedSprite2D.play("open"+str(skin_num[skin]))
	$StaticBody2D/AnimatedSprite2D.stop()
	$StaticBody2D/AnimatedSprite2D.frame=0
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)

func on_body_enterd(body):
	if not locked:
		if body.is_in_group("player") or body.is_in_group("enemies"):
			if bodies_in() > 0 and bodies_in()<2:
				$StaticBody2D/AnimatedSprite2D.play("open"+str(skin_num[skin]))
				$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
				$StaticBody2D/LightOccluder2D.hide()

func on_body_exited(body):
	if not locked:
		if body.is_in_group("player") or body.is_in_group("enemies"):
			if bodies_in() < 1:
				$StaticBody2D/AnimatedSprite2D.play_backwards("open"+str(skin_num[skin]))
				$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
				$StaticBody2D/LightOccluder2D.show()


func bodies_in() -> int:
	var bodies=get_overlapping_bodies()
	var bodies_count=0
	for body in bodies:
		if body.is_in_group("player") or body.is_in_group("enemies"):
			bodies_count=bodies_count+1
	return bodies_count
