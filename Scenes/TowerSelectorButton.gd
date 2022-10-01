extends Button

@export var tower: PackedScene

var tower_selector : Control
var clan : int

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_selector = get_node("/root/Game/GUI/TowerSelectionGUI")
	
	connect("pressed", _on_Pressed)
	pass # Replace with function body.

func _on_Pressed():
	print(tower)
	tower_selector.select_tower(tower, icon)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
