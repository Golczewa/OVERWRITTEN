extends AnimatedSprite2D
var dir_: Vector2? = null

## Plays the walk animation and stores the movement direction.
func walk(dir: Vector2) -> void:
	play("walk2")
	dir_=dir
	
func stop_walking() -> void:
	pause()
	frame=0

func _physics_process(_delta: float) -> void:
	if dir_:
		rotation=dir_.angle()

## Plays walk animation while facing the given world position.
func walk_anim(pos: Vector2) -> void:
	play("walk2")
	look_at(pos)
	dir_=null
