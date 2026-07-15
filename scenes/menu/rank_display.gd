extends HBoxContainer


func display(rank:String):
	match rank:
		"S":
			$Label2.modulate=Color.PURPLE
		"A":
			$Label2.modulate=Color.BLUE
		"B":
			$Label2.modulate=Color.GREEN
		"C":
			$Label2.modulate=Color.YELLOW
		"D":
			$Label2.modulate=Color.ORANGE
		_:
			$Label2.modulate=Color.WHITE
			rank="-"
	$Label2.text=rank