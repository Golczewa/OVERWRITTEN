extends MenuWindow


func setup(text: String):
	print($AspectRatioContainer.size)
	$Label.text = text
	open()
	print($AspectRatioContainer.size)
