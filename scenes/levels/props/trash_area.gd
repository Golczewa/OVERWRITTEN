extends ReferenceRect

@export var rand_seed:int=2137
@export var density:int=40
var trash_pack:PackedScene=preload("res://scenes/levels/props/trash_steelmill.tscn")

func _ready() -> void:
	var rng=RandomNumberGenerator.new()
	rng.seed=rand_seed
	generate_trash(rng)

func generate_trash(rand:RandomNumberGenerator)->void:
	var max_x=size.x
	var max_y=size.y
	for i in range((max_x+max_y)/density):
		var trash_x=rand.randf_range(0,max_x)
		var trash_y=rand.randf_range(0,max_y)
		var trash_pos=Vector2(trash_x,trash_y)
		var trash=trash_pack.instantiate()
		trash.position=trash_pos
		trash.skin="generator"
		trash.skin_int=rand.randi_range(0,trash.skin_num.size())
		trash.rotate(rand.randf_range(0,6.28))
		add_child(trash)
