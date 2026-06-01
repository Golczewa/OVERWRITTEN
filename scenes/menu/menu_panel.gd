extends Panel

@onready var close_button:Button=$Panel/Button
@export var title:String="Title.ovr"

func _ready() -> void:
	$Panel/Label.text=title