extends Node

const WEAPONS_PATH := "res://config/weapons.cfg"
const LEVELS_PATH := "res://config/levels.cfg"

const PLAYER_USER_PATH := "user://player.cfg"
const PLAYER_DEFAULTS_PATH := "res://config/player.defaults.cfg"
const LEVELS_PROGRESS_PATH := "user://levels_progress.cfg"
const LEVELS_PROGRESS_DEFAULTS_PATH := "res://config/levels_progress.defaults.cfg"

const PROGRESS_KEYS: Array[String] = ["unlocked", "score", "rank", "namedroped"]

var weapons: ConfigFile
var levels: ConfigFile
var levels_progress: ConfigFile
var player_config: ConfigFile

var encrypted := false
var encrypton_key: PackedByteArray


func _ready() -> void:
	#if encrypted:
	#	encrypton_key = Keys.config_encription_key.hex_decode()
	load_all()
	call_deferred("apply_player_settings")


func load_all() -> void:
	weapons = _load_cfg(WEAPONS_PATH)
	levels = _load_cfg(LEVELS_PATH)
	levels_progress = _load_or_create_levels_progress()
	player_config = _load_or_create_player_config()


func apply_player_settings() -> void:
	var window := get_window()
	var mode: String = player_config.get_value("settings", "mode", "Fullscreen")
	if mode == "Fullscreen":
		window.mode = Window.MODE_FULLSCREEN
	else:
		var resolution: String = player_config.get_value("settings", "resolution", "")
		var dimensions := resolution.split("x")
		if dimensions.size() == 2:
			var size := Vector2i(int(dimensions[0]), int(dimensions[1]))
			if size.x > 0 and size.y > 0:
				window.mode = Window.MODE_WINDOWED
				window.size = size
				window.move_to_center()

	AudioPlayer.change_music_volume(
		clampf(float(player_config.get_value("settings", "music", 1.0)), 0.0, 1.0)
	)
	AudioPlayer.change_sfx_volume(
		clampf(float(player_config.get_value("settings", "sfx", 1.0)), 0.0, 1.0)
	)


func reload_player_config() -> void:
	player_config = _load_cfg(PLAYER_USER_PATH)


func save_player_config() -> Error:
	var err
	if encrypted:
		err = player_config.save_encrypted(PLAYER_USER_PATH, encrypton_key)
	else:
		err = player_config.save(PLAYER_USER_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [PLAYER_USER_PATH, err])
	return err


func save_levels_progress() -> Error:
	var err
	if encrypted:
		err = levels_progress.save_encrypted(LEVELS_PROGRESS_PATH, encrypton_key)
	else:
		err = levels_progress.save(LEVELS_PROGRESS_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [LEVELS_PROGRESS_PATH, err])
	return err


func reload_levels_progress() -> void:
	levels_progress = _load_cfg(LEVELS_PROGRESS_PATH)


func reset_player_config() -> void:
	if encrypted:
		var config: ConfigFile = _load_cfg(PLAYER_DEFAULTS_PATH)
		config.save_encrypted(PLAYER_USER_PATH, encrypton_key)
		return
	else:
		return _copy_default_to_user(PLAYER_DEFAULTS_PATH, PLAYER_USER_PATH)


func reset_levels_progress() -> void:
	if encrypted:
		var config: ConfigFile = _load_cfg(LEVELS_PROGRESS_DEFAULTS_PATH)
		config.save_encrypted(LEVELS_PROGRESS_PATH, encrypton_key)
	else:
		return _copy_default_to_user(LEVELS_PROGRESS_DEFAULTS_PATH, LEVELS_PROGRESS_PATH)


func reset_all() -> void:
	reset_player_config()
	reset_levels_progress()


func _load_or_create_player_config() -> ConfigFile:
	if not FileAccess.file_exists(PLAYER_USER_PATH):
		if encrypted:
			var config: ConfigFile = _load_cfg(PLAYER_DEFAULTS_PATH)
			config.save_encrypted(PLAYER_USER_PATH, encrypton_key)
		else:
			return _copy_default_to_user(PLAYER_DEFAULTS_PATH, PLAYER_USER_PATH)
	return _load_cfg(PLAYER_USER_PATH)


func _load_or_create_levels_progress() -> ConfigFile:
	if not FileAccess.file_exists(LEVELS_PROGRESS_PATH):
		if encrypted:
			var config: ConfigFile = _load_cfg(LEVELS_PROGRESS_DEFAULTS_PATH)
			config.save_encrypted(LEVELS_PROGRESS_PATH, encrypton_key)
		else:
			return _copy_default_to_user(LEVELS_PROGRESS_DEFAULTS_PATH, LEVELS_PROGRESS_PATH)
	return _load_cfg(LEVELS_PROGRESS_PATH)


func _copy_default_to_user(defaults_path: String, user_path: String) -> ConfigFile:
	var err := DirAccess.copy_absolute(defaults_path, user_path)
	if err != OK:
		push_error("Config copy error: %s -> %s (code %s)" % [defaults_path, user_path, err])
	return _load_cfg(user_path)


func _load_cfg(path: String) -> ConfigFile:
	var config := ConfigFile.new()
	var err
	if encrypted and (path == PLAYER_USER_PATH or path == LEVELS_PROGRESS_PATH):
		err = config.load_encrypted(path, encrypton_key)
	else:
		err = config.load(path)
	if err != OK:
		push_error("Config loading error: %s (code %s)" % [path, err])
	return config
