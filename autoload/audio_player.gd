extends Node

@onready var sfx_player:AudioStreamPlayer=$AudioStreamPlayer
@onready var music_player:AudioStreamPlayer=$AudioStreamPlayer2

#UI SFX
@onready var menu_window_open:Resource=preload("res://asstets/sfx/Ting_Pitched_Down.wav")
@onready var menu_window_close:Resource=preload("res://asstets/sfx/Ting_Pitched_Down_Backwards2.wav")

#MUSIC
@onready var menu_theme:Resource=preload("res://asstets/music/Polaris FULL TRACK.ogg")


func play(sound:Resource):
	sfx_player.stream=sound
	sfx_player.play()

func play_music(sound:Resource):
	music_player.stream=sound
	music_player.play()

func stop_music():
	music_player.stop()