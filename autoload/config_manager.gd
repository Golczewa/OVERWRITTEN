extends Node

const WEAPONS_PATH := "res://config/weapons.cfg"
const PLAYER_PATH := "res://config/player.cfg"
const LEVELS_PATH := "res://config/levels.cfg"
const LEVELS_JSON_PATH := "res://config/levels.json"

var weapons: ConfigFile
var player_config: ConfigFile
var levels: ConfigFile
var levels_json: Variant


func _ready() -> void:
	load_all()


func load_all() -> void:
	weapons = _load_cfg(WEAPONS_PATH)
	player_config = _load_cfg(PLAYER_PATH)
	levels = _load_cfg(LEVELS_PATH)


func reload_player_config() -> void:
	player_config = _load_cfg(PLAYER_PATH)


func save_player_config() -> Error:
	var err := player_config.save(PLAYER_PATH)
	if err != OK:
		push_error("Config save error: %s (code %s)" % [PLAYER_PATH, err])
	return err


func load_levels_json() -> Variant:
	var file := FileAccess.open(LEVELS_JSON_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open: %s" % LEVELS_JSON_PATH)
		return null
	var content := file.get_as_text()
	file.close()
	var json := JSON.new()
	var error := json.parse(content)
	if error != OK:
		push_error("JSON parsing error in %s" % LEVELS_JSON_PATH)
		return null
	levels_json = json.data
	return levels_json


func _load_cfg(path: String) -> ConfigFile:
	var config := ConfigFile.new()
	var err := config.load(path)
	if err != OK:
		push_error("Config loading error: %s (code %s)" % [path, err])
	return config
