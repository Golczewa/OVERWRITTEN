extends StaticBody2D
var waves:Array
var wave_remain
var wave_counter=0
var _floor
@export var mirrored:bool=false

func _ready() -> void:
	_floor=get_parent()
	if mirrored:
		scale=Vector2(1,-1)
	
func spawn_wave():
	if( wave_counter<=wave_remain):
		$AnimatedSprite2D.play("default")
		var wave=waves[wave_counter]
		for enemy in wave:
			for i in range(enemy[0]):
				var enemy_inst=enemy[1].instantiate()
				enemy_inst.global_position=$Marker2D.global_position
				enemy_inst.player_sighted=true
				_floor.get_node("enemies").add_child(enemy_inst)
				await  get_tree().create_timer(1).timeout
		wave_counter=wave_counter+1
		$AnimatedSprite2D.play_backwards("default")
	else :
		wave_remain=0
