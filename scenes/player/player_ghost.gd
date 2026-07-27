extends GPUParticles2D

func dashEffect(direction:Vector2):
	var dirx=direction.x
	var diry=direction.y
	process_material.direction=Vector3(-dirx,-diry,0)
	emitting=true
