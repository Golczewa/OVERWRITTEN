extends Node

@export var music_volume: float = -2
@export var sfx_volume: float = 1

@onready var sfx_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music_player: AudioStreamPlayer = $AudioStreamPlayer2

#UI SFX
@onready
var menu_window_open: Resource = preload("res://asstets/sfx/normalized/Ting_Pitched_Down.wav")
@onready var menu_window_close: Resource = preload(
	"res://asstets/sfx/normalized/Ting_Pitched_Down_Backwards2.wav"
)
@onready
var weapon_equip: Resource = preload("res://asstets/sfx/normalized/Click_Combo_5_Pitched_Up.wav")

#MUSIC
@onready var menu_theme: Resource = preload("res://asstets/music/Polaris FULL TRACK.ogg")
@onready var level_1_theme: Resource = preload("res://asstets/music/Spinner FULL TRACK.ogg")
@onready var level_4_theme: Resource=preload("res://asstets/music/Anexodus FULL TRACK LOOPABLE.ogg")


func _ready() -> void:
	sfx_player.volume_db = sfx_volume
	music_player.volume_db = music_volume


func play(sound: Resource):
	sfx_player.stream = sound
	sfx_player.play()


func play_music(sound: Resource):
	if music_player.bus == "Pause":
		music_player.bus = "Master"
	if music_player.volume_db == -80:
		music_player.volume_db = music_volume
	music_player.stream = sound
	music_player.play()


func stop_music():
	music_player.stop()


func volume_up(time = 1):
	music_player.volume_db = -80
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(music_player, "volume_db", music_volume, time)
	await tween.finished

func volume_down(time=1):
	music_player.volume_db = music_volume
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(music_player, "volume_db", -80, time)
	await tween.finished

func play_with_entrance(music: Resource, time = 1):
	music_player.stream = music
	music_player.volume_db = -80
	music_player.play()
	volume_up(time)


func pause_effect():
	print("buses available: ", AudioServer.bus_count)
	for i in AudioServer.bus_count:
		print(i, ": ", AudioServer.get_bus_name(i))
	music_player.bus = "Pause"
	print("rev ", music_player.bus)


func unpause_effect():
	music_player.bus = "Master"
	print("no rev", music_player.bus)


func death_pause(time = 1):
	var tween := create_tween()
	tween.tween_property(music_player, "pitch_scale", 0.01, time)
	await tween.finished
	music_player.volume_db = -80


func death_unpause(time = 1):
	music_player.volume_db = music_volume
	var tween := create_tween()
	tween.tween_property(music_player, "pitch_scale", 1, time)
	await tween.finished
