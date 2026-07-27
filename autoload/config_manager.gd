extends Node

const WEAPONS_PATH := "res://config/weapons.cfg"
const LEVELS_PATH := "res://config/levels.cfg"
const PLAYER_USER_PATH := "user://player.cfg"
const LEVELS_PROGRESS_PATH := "user://levels_progress.cfg"
const LEVELS_PROGRESS_DEFAULTS_PATH := "res://config/levels_progress.defaults.cfg"

const PROGRESS_KEYS: Array[String] = ["unlocked", "score", "rank", "namedroped"]

var weapons: ConfigFile
var levels: ConfigFile
var levels_progress: ConfigFile
var player_config: ConfigFile


func _ready() -> void:
	load_all()


## Loads all config files from disk or creates defaults where needed.
func load_all() -> void:
	weapons = _load_cfg(WEAPONS_PATH)
	levels = _load_cfg(LEVELS_PATH)
	levels_progress = _load_or_create_levels_progress()
	player_config = _load_or_create_player_config()


## Returns a level or progress value, routing progress keys to the user save.
func get_level_value(section: String, key: String, default: Variant = null) -> Variant:
	if key in PROGRESS_KEYS:
		return levels_progress.get_value(section, key, default)
	return levels.get_value(section, key, default)


## Persists a progress-only level value (unlocked, score, rank, namedroped).
func set_level_value(section: String, key: String, value: Variant) -> void:
	if key not in PROGRESS_KEYS:
		push_error("Cannot set static level key: %s" % key)
		return
	levels_progress.set_value(section, key, value)


## Reloads player weapon preferences from user://player.cfg.
func reload_player_config() -> void:
	player_config = _load_cfg(PLAYER_USER_PATH)


## Saves player config to disk; returns the FileAccess error code.
func save_player_config() -> Error:
	var err: Error = player_config.save(PLAYER_USER_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [PLAYER_USER_PATH, err])
	return err


## Saves level progress to disk; returns the FileAccess error code.
func save_levels_progress() -> Error:
	var err: Error = levels_progress.save(LEVELS_PROGRESS_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [LEVELS_PROGRESS_PATH, err])
	return err


## Reloads level progress from user://levels_progress.cfg.
func reload_levels_progress() -> void:
	levels_progress = _load_cfg(LEVELS_PROGRESS_PATH)


func _load_or_create_player_config() -> ConfigFile:
	if not FileAccess.file_exists(PLAYER_USER_PATH):
		var config: ConfigFile = ConfigFile.new()
		config.set_value("weapons", "left", 1)
		config.set_value("weapons", "right", 2)
		config.save(PLAYER_USER_PATH)
	return _load_cfg(PLAYER_USER_PATH)


func _load_or_create_levels_progress() -> ConfigFile:
	if FileAccess.file_exists(LEVELS_PROGRESS_PATH):
		return _load_cfg(LEVELS_PROGRESS_PATH)

	var config: ConfigFile = _load_cfg(LEVELS_PROGRESS_DEFAULTS_PATH)
	for section: String in levels.get_sections():
		if not config.has_section(section):
			config.set_value(section, "unlocked", false)
			config.set_value(section, "score", 0)
			config.set_value(section, "rank", "-")
			config.set_value(section, "namedroped", false)
	config.save(LEVELS_PROGRESS_PATH)
	return config


func _load_cfg(path: String) -> ConfigFile:
	var config: ConfigFile = ConfigFile.new()
	var err: Error = config.load(path)
	if err != OK:
		push_error("Config loading error: %s (code %s)" % [path, err])
	return config
