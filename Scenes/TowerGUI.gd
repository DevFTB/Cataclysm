extends Control

var tower : Tower = null

@export var spot_selector_path : NodePath

@onready var spot_selector = get_node(spot_selector_path)
@onready var details_parent = $VSplitContainer/Control/TowerDetails

# Called when the node enters the scene tree for the first time.
func _ready():
	unset_tower()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_minimise_button_toggled(button_pressed):
	$VSplitContainer/Control.visible = button_pressed
	pass # Replace with function body.

func set_tower(tower) -> void:
	self.tower = tower
	details_parent.visible = true
	
	details_parent.get_node("TowerTitle").text = tower.tower_name
	details_parent.get_node("TowerImage").texture = tower.ui_image
	
	details_parent.get_node("TowerDescription").text  = generate_description(tower)
	var op_button = details_parent.get_node("TargetingOptionButton") as OptionButton
	
	if tower.is_aoe:
		if op_button.item_count < 3:
			op_button.add_item("Spot", 2)
	else:
		if op_button.item_count > 2:
			op_button.remove_item(2)
			
	details_parent.get_node("TowerSetSpotButton").visible = tower.is_aoe and op_button.selected == 2
	pass

func generate_description(tower: Tower) -> String:
	var format_string = "Element: %s\n\nType:%s\nDamage: %s\nAttack Duration: %s"
	return format_string % [Game.elementToString(tower.element), "AOE" if tower.is_aoe else "Single Target", tower.damage, tower.attack_duration]
	pass
	
func unset_tower() -> void:
	self.tower = null
	details_parent.visible = false
	pass

func confirm_spot(spot):
	if (spot == null) or (spot != null and (spot - tower.global_position).length() < tower.attack_range):
		tower.set_spot(spot)
		details_parent.get_node("TowerSetSpotButton").set_toggle(false)
		print("Spot %s was selected" % spot)	
		return true
	else:
		return false

func _on_targeting_option_button_item_selected(index):
	details_parent.get_node("TowerSetSpotButton").visible = tower.is_aoe and index == 2
	pass # Replace with function body.

func _on_tower_set_spot_button_pressed():
	if tower != null:
		if not details_parent.get_node("TowerSetSpotButton")._toggled:
			spot_selector.start_spot_selection(tower.aoe_range)
		else: 
			spot_selector.end_spot_selection(null)
		pass # Replace with function body.
	pass # Replace with function body.
