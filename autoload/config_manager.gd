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


## Initializes configuration manager by loading all configuration files on node ready.
func _ready() -> void:
	load_all()


## Loads all weapons, levels, player, and level progress configuration files.
func load_all() -> void:
	weapons = _load_cfg(WEAPONS_PATH)
	levels = _load_cfg(LEVELS_PATH)
	levels_progress = _load_or_create_levels_progress()
	player_config = _load_or_create_player_config()


## Retrieves a configuration value for a level section from progress or static config.
func get_level_value(section: String, key: String, default = null):
	if key in PROGRESS_KEYS:
		return levels_progress.get_value(section, key, default)
	return levels.get_value(section, key, default)


## Sets a progress tracking key value for a specified level section.
func set_level_value(section: String, key: String, value) -> void:
	if key not in PROGRESS_KEYS:
		push_error("Cannot set static level key: %s" % key)
		return
	levels_progress.set_value(section, key, value)


## Reloads the player configuration from user storage.
func reload_player_config() -> void:
	player_config = _load_cfg(PLAYER_USER_PATH)


## Saves current player configuration settings to disk.
func save_player_config() -> Error:
	var err := player_config.save(PLAYER_USER_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [PLAYER_USER_PATH, err])
	return err


## Saves current level progress and completion status to disk.
func save_levels_progress() -> Error:
	var err := levels_progress.save(LEVELS_PROGRESS_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [LEVELS_PROGRESS_PATH, err])
	return err


## Reloads level progress data from user storage.
func reload_levels_progress() -> void:
	levels_progress = _load_cfg(LEVELS_PROGRESS_PATH)


## Resets the player config back to its shipped default, overwriting the user file on disk.
func reset_player_config() -> void:
	player_config = _copy_default_to_user(PLAYER_DEFAULTS_PATH, PLAYER_USER_PATH)


## Resets level progress back to its shipped default (plus any missing level sections),
## overwriting the user file on disk.
func reset_levels_progress() -> void:
	levels_progress = _build_default_levels_progress_config()
	var err := levels_progress.save(LEVELS_PROGRESS_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [LEVELS_PROGRESS_PATH, err])


## Resets every user config (player + level progress) back to its shipped default.
func reset_all() -> void:
	reset_player_config()
	reset_levels_progress()


## Loads player configuration file, creating it from the default template if absent.
func _load_or_create_player_config() -> ConfigFile:
	if not FileAccess.file_exists(PLAYER_USER_PATH):
		return _copy_default_to_user(PLAYER_DEFAULTS_PATH, PLAYER_USER_PATH)
	return _load_cfg(PLAYER_USER_PATH)


## Loads level progress file or initializes default progress for all levels.
func _load_or_create_levels_progress() -> ConfigFile:
	if FileAccess.file_exists(LEVELS_PROGRESS_PATH):
		return _load_cfg(LEVELS_PROGRESS_PATH)

	var config := _build_default_levels_progress_config()
	config.save(LEVELS_PROGRESS_PATH)
	return config


## Builds a ConfigFile with default level progress values for all known sections.
func _build_default_levels_progress_config() -> ConfigFile:
	var config := _load_cfg(LEVELS_PROGRESS_DEFAULTS_PATH)
	for section in levels.get_sections():
		if not config.has_section(section):
			config.set_value(section, "unlocked", false)
			config.set_value(section, "score", 0)
			config.set_value(section, "rank", "-")
			config.set_value(section, "namedroped", false)
	return config


## Copies a bundled default config (res://) over the destination user path, then loads it.
func _copy_default_to_user(defaults_path: String, user_path: String) -> ConfigFile:
	var err := DirAccess.copy_absolute(defaults_path, user_path)
	if err != OK:
		push_error("Config copy error: %s -> %s (code %s)" % [defaults_path, user_path, err])
	return _load_cfg(user_path)


## Helper method to load a ConfigFile from the specified file path.
func _load_cfg(path: String) -> ConfigFile:
	var config := ConfigFile.new()
	var err := config.load(path)
	if err != OK:
		push_error("Config loading error: %s (code %s)" % [path, err])
	return config