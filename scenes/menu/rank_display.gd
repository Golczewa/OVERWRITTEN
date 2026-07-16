extends HBoxContainer


func display(rank:String):
	$Label.text="Rank: "
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
		"Cheats":
			rank=""
			$Label.text="Cheats used"
		_:
			$Label2.modulate=Color.WHITE
			rank="-"
	$Label2.text=rank
