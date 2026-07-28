extends Label

var orginal_name


func _ready() -> void:
	orginal_name = text
	namedrop()


func namedrop():
	var name_sum = ""
	text = ""
	for c in orginal_name:
		name_sum += c
		text = name_sum + "_"
		$Timer.start(0.1)
		await $Timer.timeout
	$Timer.start(2)
	await $Timer.timeout
	begone()


func begone():
	for i in range(len(orginal_name), -1, -1):
		text = orginal_name.left(i) + "_"
		$Timer.start(0.03)
		await $Timer.timeout
	queue_free()
