extends AnimatedSprite2D

@export_enum("right", "left_upper", "right_upper") var hand: String = "right"

var dancing:bool=true
var dance_tween:Tween
@onready var player:CharacterBody2D=get_tree().get_first_node_in_group("player")

func _ready() -> void:
    if ConfigManager.player_config.get_value("hands",hand,true):
        queue_free()
    $Area2D.body_entered.connect(on_body_entered)
    if hand=="right":
        frame=0
    else :
        frame=1
    dance()


func dance(_offset:float=10,time:float=0.5):
    while dancing:
        dance_tween=create_tween()
        dance_tween.tween_property(self,"global_position",global_position+Vector2(0,_offset),time)
        dance_tween.tween_property(self,"global_position",global_position-Vector2(0,_offset),time)
        await dance_tween.finished


func on_body_entered(body:Node2D):
    if body == player:
        ConfigManager.player_config.set_value("hands",hand,true)
        ConfigManager.save_player_config()
        player.equip_weapons()
        queue_free()