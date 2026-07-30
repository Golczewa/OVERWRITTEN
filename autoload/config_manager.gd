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



## Loads player configuration file or creates a default one if absent.
func _load_or_create_player_config() -> ConfigFile:
	if not FileAccess.file_exists(PLAYER_USER_PATH):
		var config := ConfigFile.new()
		config.set_value("weapons", "left", 1)
		config.set_value("weapons", "right", 2)
		config.save(PLAYER_USER_PATH)
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


## Helper method to load a ConfigFile from the specified file path.
func _load_cfg(path: String) -> ConfigFile:
	var config := ConfigFile.new()
	var err := config.load(path)
	if err != OK:
		push_error("Config loading error: %s (code %s)" % [path, err])
	return config
