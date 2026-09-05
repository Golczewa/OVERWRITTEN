extends Node

@export var music_volume: float = -2
@export var sfx_volume: float = 3

@onready var sfx_player: AudioStreamPlayer = $UI_SFX
@onready var music_player: AudioStreamPlayer = $MUSIC
@export var game_sfx_players: Array[AudioStreamPlayer]
@export var game_sfx_loop_players: Array[AudioStreamPlayer]

#UI SFX
const menu_window_open: AudioStreamWAV = preload("res://asstets/sfx/Ting_Pitched_Down.wav")
const menu_window_close: AudioStreamWAV = preload(
	"res://asstets/sfx/Ting_Pitched_Down_Backwards2.wav"
)
const weapon_equip: AudioStreamWAV = preload("res://asstets/sfx/Click_Combo_5_Pitched_Up.wav")

#MUSIC
const menu_theme: String = "res://asstets/music/Polaris FULL TRACK.ogg"
const level_1_theme: String = "res://asstets/music/Neon After Dark FULL TRACK LOOPABLE.ogg"
const level_2_theme: String = "res://asstets/music/Corporate Skyline FULL TRACK LOOPABLE.ogg"
const level_3_theme: String = "res://asstets/music/Black Horses FULL TRACK LOOPABLE.ogg"
const level_4_theme: String = "res://asstets/music/Anexodus FULL TRACK LOOPABLE.ogg"

#IN GAME SFX

const pickup_hand: AudioStreamWAV = preload("res://asstets/sfx/Append.wav")
const startup: AudioStreamWAV = preload("res://asstets/sfx/startup.wav")
const explosion1: AudioStreamWAV = preload("res://asstets/sfx/explosion.wav")
const explosion2: AudioStreamWAV = preload("res://asstets/sfx/explosion2.wav")
const revolver_shot: AudioStreamWAV = preload("res://asstets/sfx/rev_shot.wav")
const lauch: AudioStreamWAV = preload("res://asstets/sfx/lauch.wav")
const shatter: AudioStreamWAV = preload("res://asstets/sfx/window_shatter.wav")
const chainsaw_running: AudioStreamWAV = preload("res://asstets/sfx/chainsaw_runing.wav")
const chainsaw_warning: AudioStreamWAV = preload("res://asstets/sfx/leader_chainsaw_warning.wav")
const punch: AudioStreamWAV = preload("res://asstets/sfx/punch_sometching.wav")
const swosh: AudioStreamWAV = preload("res://asstets/sfx/punch_air.wav")
const slash: AudioStreamWAV = preload("res://asstets/sfx/sword.wav")
const patchwork_shot: AudioStreamWAV = preload("res://asstets/sfx/pach_gunshot.wav")
const coat: AudioStreamWAV = preload("res://asstets/sfx/cloth.wav")
const virtual_guy_deadth: AudioStreamWAV = preload("res://asstets/sfx/virtual_death.wav")
const hp_loading:AudioStreamWAV=preload("res://asstets/sfx/juice.wav")

const bullet_rickoshet1: AudioStreamWAV = preload("res://asstets/sfx/bullet_rickoshet1.wav")
const bullet_rickoshet2: AudioStreamWAV = preload("res://asstets/sfx/bullet_rickoshet2.wav")
const bullet_rickoshet3: AudioStreamWAV = preload("res://asstets/sfx/bullet_rickoshet3.wav")
const bullet_rickoshet4: AudioStreamWAV = preload("res://asstets/sfx/bullet_rickoshet4.wav")

const hurt_1:AudioStreamWAV = preload("res://asstets/sfx/virtual_death.wav")
const hurt_2:AudioStreamWAV = preload("res://asstets/sfx/Glitch_15.wav")
const hurt_3:AudioStreamWAV = preload("res://asstets/sfx/Glitch_10.wav")
const hurt_4:AudioStreamWAV = preload("res://asstets/sfx/Glitch_20.wav")





func _ready() -> void:
	sfx_player.volume_db = sfx_volume
	music_player.volume_db = music_volume
	for stream in game_sfx_players:
		stream.volume_db = sfx_volume


func play(sound: AudioStreamWAV):
	sfx_player.stream = sound
	sfx_player.play()



func play_game_sfx(sound: AudioStreamWAV, max_count := 3) -> void:
	var free_stream: AudioStreamPlayer = null
	var same_sound_count := 0
	for stream in game_sfx_players:
		if stream.playing and stream.stream == sound:
			same_sound_count += 1
			if same_sound_count >= max_count:
				return
		elif not stream.playing and free_stream == null:
			free_stream = stream
	if free_stream:
		free_stream.stream = sound
		free_stream.play()


func play_game_sfx_loop(sound: AudioStreamWAV, max_count := 2) -> AudioStreamPlayer:
	var free_stream: AudioStreamPlayer = null
	var same_sound_count := 0
	for stream in game_sfx_loop_players:
		if (
			stream.playing
			and stream.stream is AudioStreamWAV
			and stream.stream.resource_path == sound.resource_path
		):
			same_sound_count += 1
			if same_sound_count >= max_count:
				return null
		elif not stream.playing and free_stream == null:
			free_stream = stream
	if free_stream:
		free_stream.stream = sound
		free_stream.play()
	return free_stream


func play_music(sound: String):
	if music_player.bus != "Master":
		music_player.bus = "Master"
	if music_player.volume_db != music_volume:
		music_player.volume_db = music_volume
	if music_player.pitch_scale != 1:
		music_player.pitch_scale = 1
	music_player.stream = load(sound)
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


func volume_down(time = 1):
	music_player.volume_db = music_volume
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(music_player, "volume_db", -80, time)
	await tween.finished


func play_with_entrance(music: String, time = 1):
	music_player.stream = load(music)
	music_player.volume_db = -80
	music_player.play()
	volume_up(time)


func pause_effect():
	music_player.bus = "Pause"


func unpause_effect():
	music_player.bus = "Master"


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


func stop_all_sfx():
	for player in game_sfx_players:
		player.stop()
	for player in game_sfx_loop_players:
		player.stop()
