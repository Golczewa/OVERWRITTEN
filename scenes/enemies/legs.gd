extends AnimatedSprite2D
var point_to_look_at
var fallow = false


func walk():
	play("walk")


func stop_walking():
	pause()
	frame = 0


func run():
	play("walk", 2)


func toogle_fallow(pos):
	point_to_look_at = pos
	fallow = true


func _physics_process(_delta: float) -> void:
	if fallow:
		look_at(point_to_look_at)
