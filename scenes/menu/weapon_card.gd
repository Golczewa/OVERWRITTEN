extends Control


func setup(name:String , img:String):
	$TextureRect.texture=load(img)
	$Label.text=name
