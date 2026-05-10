extends Control

func _ready() -> void:
	hide()
	$Button.pressed.connect(hidee)

func setup(score:Dictionary):
	show()
	count_score(score)
	$time.text="Time: "+str(score["time"])
	$deaths.text="Deaths: "+str(score["deaths"])
	$used.text="Healing used: "+str(score["hused"])
	$used2.text="Score: "+str(score["rank"])
	$rank.text="Rank: "+score["rank"]

func count_score(score:Dictionary):
	pass

func hidee():
	hide()
