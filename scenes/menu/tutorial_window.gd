extends MenuWindow


func setup(text: String):
	$Label.text = text
	open()
	print($AspectRatioContainer.size)