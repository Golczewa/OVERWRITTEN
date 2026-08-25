extends Floor


func _ready() -> void:
	if ConfigManager.player_config.get_value("unlocked_weapons", str(1), true):
		cutscenes -= 1
	_set_waves()
	if down_node is Marker2D:
		spawn = down_node.global_position
	else:
		spawn = down_node.marker.global_position
	if up_node is Marker2D:
		exit = up_node.global_position
	else:
		exit = up_node.marker.global_position
	for i in range(len(enemy_spawners)):
		enemy_spawners[i].waves = waves[i]
		enemy_spawners[i].wave_remain = len(waves[i]) - 1
		waves_number += len(waves[i])
