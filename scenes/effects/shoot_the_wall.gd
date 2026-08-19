extends GPUParticles2D


func _ready() -> void:
	life()


func life():
	print("emitted")
	emitting = true
	finished.connect(queue_free)
