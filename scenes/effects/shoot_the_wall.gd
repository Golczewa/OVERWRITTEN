extends GPUParticles2D


func _ready() -> void:
	life()


func life():
	emitting = true
	AudioPlayer.play_game_sfx(AudioPlayer.get("bullet_rickoshet" + str(randi_range(1, 4))), 5)
	finished.connect(queue_free)
