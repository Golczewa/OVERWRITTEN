extends PanelContainer


@export var title:String="Title";
@onready var close_button:Button=$VBoxContainer/PanelContainer/HBoxContainer/Button;

func _ready() -> void:
	title=title.replace(" ","_")
	$VBoxContainer/PanelContainer/HBoxContainer/Label.text=" "+title+".ovr"


