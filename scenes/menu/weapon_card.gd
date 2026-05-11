extends Control


func _ready() -> void:
	pass # Replace with function body.


func setup(name:String , img:String):
	$TextureRect.texture=load(img)
	$Label.text=name
