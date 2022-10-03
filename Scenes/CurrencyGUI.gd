extends HBoxContainer

func _ready():
	get_node("/root/Game").connect("currency_changed", update_currency)

func update_currency(value):
	$Label.text = str(value)
	pass
