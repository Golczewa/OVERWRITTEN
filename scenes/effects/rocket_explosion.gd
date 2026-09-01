extends AnimatedSprite2D


func _ready() -> void:
	play("default")
	AudioPlayer.play_game_sfx(AudioPlayer.get("explosion" + str(1)))
	await animation_finished
	queue_free()
