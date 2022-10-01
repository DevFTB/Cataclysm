extends Control

var tower : Tower = null

@onready var details_parent = $VSplitContainer/Control/TowerDetails

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_minimise_button_toggled(button_pressed):
	$VSplitContainer/Control.visible = button_pressed
	pass # Replace with function body.

func set_tower(tower) -> void:
	self.tower = tower

	details_parent.get_node("TowerTitle").text = tower.tower_name
	details_parent.get_node("TowerImage").texture = tower.ui_image
	
	details_parent.get_node("TowerDescription").text  = generate_description(tower)

	pass

func generate_description(tower: Tower) -> String:
	var format_string = "Element: %s\n\nType:%s\nDamage: %s\nAttack Duration: %s"
	return format_string % [Game.elementToString(tower.element), "AOE" if tower.is_aoe else "Single Target", tower.damage, tower.attack_duration]
	pass
	
func unset_tower() -> void:
	self.tower = null

	pass
