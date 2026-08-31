extends Node

@export var music_volume:float=-1
@export var sfx_volume:float=1

@onready var sfx_player:AudioStreamPlayer=$AudioStreamPlayer
@onready var music_player:AudioStreamPlayer=$AudioStreamPlayer2

#UI SFX
@onready var menu_window_open:Resource=preload("res://asstets/sfx/normalized/Ting_Pitched_Down.wav")
@onready var menu_window_close:Resource=preload("res://asstets/sfx/normalized/Ting_Pitched_Down_Backwards2.wav")
@onready var weapon_equip:Resource=preload("res://asstets/sfx/normalized/Click_Combo_5_Pitched_Up.wav")

#MUSIC
@onready var menu_theme:Resource=preload("res://asstets/music/Polaris FULL TRACK.ogg")
@onready var level_1_theme:Resource=preload("res://asstets/music/Spinner FULL TRACK.ogg")

func _ready() -> void:
	sfx_player.volume_db=sfx_volume
	music_player.volume_db=music_volume

func play(sound:Resource):
	sfx_player.stream=sound
	sfx_player.play()

func play_music(sound:Resource):
	music_player.stream=sound
	music_player.play()

func stop_music():
	music_player.stop()


func volume_up(time=1):
	music_player.volume_db=-80
	var tween:Tween=create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(music_player,"volume_db",music_volume,time)
	await tween.finished

func play_with_entrance(music:Resource,time=1):
	music_player.stream=music
	music_player.volume_db=-80
	music_player.play()
	volume_up()

