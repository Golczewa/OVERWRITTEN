extends AnimatedSprite2D
var dir_

func walk(dir):
	play("walk")
	dir_=dir
	
func stop_walking():
	pause()
	frame=0

func _physics_process(delta: float) -> void:
	if dir_:
		rotation=dir_.angle()
