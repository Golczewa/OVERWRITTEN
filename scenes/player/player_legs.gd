extends AnimatedSprite2D
var dir_


func walk(dir):
	play("walk2")
	dir_ = dir


func stop_walking():
	pause()
	frame = 0


func _physics_process(_delta: float) -> void:
	if dir_:
		rotation = dir_.angle()


func walk_anim(pos: Vector2):
	play("walk2")
	look_at(pos)
	dir_ = null
