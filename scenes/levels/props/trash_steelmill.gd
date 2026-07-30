extends AnimatedSprite2D

@export_enum(
	"hearth",
	"plate1",
	"screw1",
	"screw2",
	"eye",
	"hand1",
	"cable1",
	"leg",
	"weel",
	"core",
	"hand",
	"cable",
	"plate2",
	"random",
	"generator"
)
var skin: String = "random"

var skin_num: Dictionary = {
	"hearth": 0,
	"plate1": 1,
	"screw1": 2,
	"screw2": 3,
	"eye": 4,
	"hand1": 5,
	"cable1": 6,
	"leg": 7,
	"weel": 8,
	"core": 9,
	"hand": 10,
	"cable": 11,
	"plate2": 12
}

var skin_int: int = 0


func _ready() -> void:
	if skin == "random":
		set_skin(randi() % skin_num.size())
	elif skin == "generator":
		set_skin(skin_int)
	else:
		set_skin(skin_num[skin])


func set_skin(num: int) -> void:
	play("default")
	stop()
	frame = num


func travel_and_melt(pos_a: Vector2, pos_b: Vector2, travel_time = 2.7) -> void:
	global_position = pos_a
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos_b, travel_time)
	await tween.finished
	await melt()
	queue_free()


func melt(melt_time: int = 1):
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate", Color.ORANGE_RED, melt_time)
	tween.tween_property(self, "scale", Vector2.ZERO, melt_time)
	await tween.finished
