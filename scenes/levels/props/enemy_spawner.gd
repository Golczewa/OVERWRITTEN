extends StaticBody2D
var waves: Array
var wave_remain
var wave_counter = 0
var _floor: Floor
var is_spawning_wave := false
@export var mirrored: bool = false
@export var give_warning: bool = false


func _ready() -> void:
	_floor = get_parent()
	if mirrored:
		scale = Vector2(1, -1)


func spawn_wave():
	if is_spawning_wave:
		return
	if wave_counter <= wave_remain:
		is_spawning_wave = true
		$AnimatedSprite2D.play("default")
		var wave = waves[wave_counter]
		for enemy in wave:
			for i in range(enemy[0]):
				AudioPlayer.play_game_sfx(AudioPlayer.alarm, 1)
				var enemy_inst: Enemy = enemy[1].instantiate()
				if give_warning:
					enemy_inst.with_warning = true
				var spawn_offset = Vector2(randf_range(-8, 8), randf_range(-8, 8))
				enemy_inst.global_position = global_position
				enemy_inst.spawn_dest = $Marker2D.global_position + spawn_offset
				enemy_inst.is_spawning = true
				enemy_inst.player_sighted = true
				_floor.get_node("enemies").add_child(enemy_inst)
				await get_tree().create_timer(1).timeout
		wave_counter += 1
		$AnimatedSprite2D.play_backwards("default")
		is_spawning_wave = false
		_floor.waves_number -= 1
	else:
		wave_remain = 0


func setup(wave: Array) -> void:
	waves = wave
	wave_remain = len(wave) - 1
