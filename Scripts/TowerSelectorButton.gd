extends Button

@export var tower: Tower

var tower_selector : Control
var clan : int

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_selector = get_node("/root/Game/GUI/TowerSelectionGUI")
	
	connect("pressed", _on_Pressed)
	pass # Replace with function body.

func _on_Pressed():
	tower_selector.select_tower(tower, icon)
	pass
