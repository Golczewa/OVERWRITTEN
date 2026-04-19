extends GPUParticles2D



func _ready() -> void:
	life()
	
func life():
	emitting=true
	finished.connect(queue_free)
