extends AnimatedSprite2D

func walk():
	play("walk")
	
func stop_walking():
	pause()
	frame=0

func  run():
	play("walk",2)
