extends Button

@export var tower: Tower

var tower_selector : Control
var clan : int

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_selector = get_node("/root/Game/GUI/TowerSelectionGUI")
	var game = get_node("/root/Game")
	game.connect("currency_changed", _on_currency_changed)
	disabled =	not game.can_buy(tower)
	connect("pressed", _on_Pressed)
	$HBoxContainer/Label.text = str(tower.currency_cost)
	
	pass # Replace with function body.

func _on_Pressed():
	tower_selector.select_tower(tower, icon)
	pass

func _on_currency_changed(new_value):
	disabled = tower.currency_cost > new_value
