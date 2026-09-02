extends Node

@export var music_volume: float = -2
@export var sfx_volume: float = 3

@onready var sfx_player: AudioStreamPlayer = $UI_SFX
@onready var music_player: AudioStreamPlayer = $MUSIC
@export var game_sfx_players: Array[AudioStreamPlayer]
@export var game_sfx_loop_players: Array[AudioStreamPlayer]

#UI SFX
@onready var menu_window_open: Resource = preload("res://asstets/sfx/Ting_Pitched_Down.wav")
@onready
var menu_window_close: Resource = preload("res://asstets/sfx/Ting_Pitched_Down_Backwards2.wav")
@onready var weapon_equip: Resource = preload("res://asstets/sfx/Click_Combo_5_Pitched_Up.wav")

#MUSIC
@onready var menu_theme: Resource = preload("res://asstets/music/Polaris FULL TRACK.ogg")
@onready var level_1_theme: Resource = preload("res://asstets/music/Spinner FULL TRACK.ogg")
@onready
var level_4_theme: Resource = preload("res://asstets/music/Anexodus FULL TRACK LOOPABLE.ogg")

#IN GAME SFX

@onready var pickup_hand: Resource = preload("res://asstets/sfx/Append.wav")
@onready var startup: Resource = preload("res://asstets/sfx/startup.wav")
@onready var explosion1: Resource = preload("res://asstets/sfx/explosion.wav")
@onready var explosion2: Resource = preload("res://asstets/sfx/explosion2.wav")
@onready var revolver_shot: Resource = preload("res://asstets/sfx/rev_shot.wav")
@onready var lauch: Resource = preload("res://asstets/sfx/lauch.wav")
@onready var shatter: Resource = preload("res://asstets/sfx/window_shatter.wav")
@onready var chainsaw_running: Resource = preload("res://asstets/sfx/chainsaw_runing.wav")
@onready var chainsaw_warning: Resource = preload("res://asstets/sfx/leader_chainsaw_warning.wav")
@onready var punch: Resource = preload("res://asstets/sfx/punch_sometching.wav")
@onready var swosh: Resource = preload("res://asstets/sfx/punch_air.wav")
@onready var slash:Resource=preload("res://asstets/sfx/sword.wav")
@onready var patchwork_shot:Resource=preload("res://asstets/sfx/pach_gunshot.wav")
@onready var coat:Resource=preload("res://asstets/sfx/cloth.wav")

@onready var bullet_rickoshet1: Resource = preload("res://asstets/sfx/bullet_rickoshet1.wav")
@onready var bullet_rickoshet2: Resource = preload("res://asstets/sfx/bullet_rickoshet2.wav")
@onready var bullet_rickoshet3: Resource = preload("res://asstets/sfx/bullet_rickoshet3.wav")
@onready var bullet_rickoshet4: Resource = preload("res://asstets/sfx/bullet_rickoshet4.wav")


func _ready() -> void:
	sfx_player.volume_db = sfx_volume
	music_player.volume_db = music_volume
	for stream in game_sfx_players:
		stream.volume_db = sfx_volume


func play(sound: Resource):
	sfx_player.stream = sound
	sfx_player.play()


func play_game_sfx(sound: AudioStream, max_count := 3) -> void:
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
	var loop: AudioStreamWAV = sound.duplicate()
	loop.loop_mode = AudioStreamWAV.LOOP_FORWARD
	var free_stream: AudioStreamPlayer = null
	var same_sound_count := 0
	for stream in game_sfx_loop_players:
		if stream.playing and stream.stream == loop:
			same_sound_count += 1
			if same_sound_count >= max_count:
				return
		elif not stream.playing and free_stream == null:
			free_stream = stream
	if free_stream:
		free_stream.stream = loop
		free_stream.play()
	return free_stream


func play_music(sound: Resource):
	if music_player.bus != "Master":
		music_player.bus = "Master"
	if music_player.volume_db != music_volume:
		music_player.volume_db = music_volume
	if music_player.pitch_scale != 1:
		music_player.pitch_scale = 1
	music_player.stream = sound
	print(music_player.volume_db)
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


func play_with_entrance(music: Resource, time = 1):
	music_player.stream = music
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
