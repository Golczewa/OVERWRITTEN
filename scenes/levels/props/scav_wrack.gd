extends StaticBody2D


func _ready() -> void:
	$PointLight2D.hide()
	$Timer.timeout.connect(flash)
	$Timer.start(1)


func flash():
	$PointLight2D.visible = !$PointLight2D.visible
	$Timer.start(1)
