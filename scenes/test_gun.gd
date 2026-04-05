extends AnimatedSprite2D
var can_attack = true
var bullet_test = preload("res://scenes/bullet_test.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale=Vector2(1,-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_RIGHT:
			if event.pressed:
				shoot()

func end_cd():
	can_attack=true

func shoot():
	if can_attack:
		var bullet = bullet_test.instantiate()
		bullet.direction = ($Marker2D.global_position - $Marker2D2.global_position).normalized()
		get_tree().current_scene.add_child(bullet) 
		bullet.global_position=$Marker2D.global_position
		can_attack=false
		get_tree().create_timer(0.5).timeout.connect(end_cd)
