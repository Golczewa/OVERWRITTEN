extends Node2D

@export_enum("pendrive", "page", "tablet") var skin = "pendrive"
@export var window_pack: PackedScene
@export var message:String="Loading..."
var window: MenuWindow
var skin_num: Dictionary = {
	"pendrive": 0,
	"page": 1,
	"tablet": 2,
}
@onready var curr_floor: Floor = get_parent()
var active := false
var dance_tween: Tween
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var load_window:MenuWindow=player.canvas.get_node("MenuWindow2")
var loaded:=false


func _ready() -> void:
	$AnimatedSprite2D.frame = skin_num[skin]
	$Area2D.body_entered.connect(show_window)
	$Area2D.body_exited.connect(hide_window)


func _physics_process(_delta: float) -> void:
	if curr_floor.cleared and not active:
		active = true
		dance()


func dance(size_offset: float = 0.15, time: float = 0.5) -> void:
	if dance_tween:
		dance_tween.kill()
	dance_tween = create_tween()
	dance_tween.set_loops()
	dance_tween.set_trans(Tween.TRANS_SINE)
	dance_tween.set_ease(Tween.EASE_IN_OUT)
	dance_tween.tween_property($AnimatedSprite2D, "scale", Vector2.ONE * (1 + size_offset), time)
	dance_tween.tween_property($AnimatedSprite2D, "scale", Vector2.ONE * (1 - size_offset), time)


func show_window(body: Node2D):
	if not active or body != player:
		return
	if not loaded:
		await load_window.load_animation(message)
		loaded=true
	player.in_menu=true
	window = window_pack.instantiate()
	player.canvas.add_child(window)
	window.show()
	window.open()


func hide_window(body: Node2D):
	if not active or body != player:
		return
	if window:
		if window.visible:
			await window.begone()
		window.queue_free()
	player.in_menu=false