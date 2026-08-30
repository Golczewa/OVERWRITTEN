extends Node

@onready var wavplayer:AudioStreamPlayer=$AudioStreamPlayer

#UI
@onready var menu_window_open:Resource=preload("res://asstets/sfx/Ting_Pitched_Down.wav")
@onready var menu_window_close:Resource=preload("res://asstets/sfx/Ting_Pitched_Down_Backwards2.wav")

func play(sound:Resource):
	wavplayer.stream=sound
	wavplayer.play()
