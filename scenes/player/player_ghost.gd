extends GPUParticles2D

## Emits dash particles in the opposite of the given direction.
func dashEffect(direction: Vector2) -> void:
	var dirx: float = direction.x
	var diry: float = direction.y
	process_material.direction=Vector3(-dirx,-diry,0)
	emitting=true
