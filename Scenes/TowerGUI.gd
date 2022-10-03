extends Control

var tower : Tower = null
var tower_instance = null

@export var spot_selector_path : NodePath

@onready var spot_selector = get_node(spot_selector_path)
@onready var details_parent = $VSplitContainer/Control/TowerDetails

@onready var game = get_node("/root/Game")

func _ready():
	unset_tower()
 
func _on_minimise_button_toggled(button_pressed):
	$VSplitContainer/Control.visible = button_pressed

func set_tower(new_tower_instance) -> void:
	tower_instance = new_tower_instance
	tower = new_tower_instance.tower
	details_parent.visible = true
	
	details_parent.get_node("TowerTitle").text = tower.tower_name
	details_parent.get_node("TowerImage").texture = tower.ui_image
	
	details_parent.get_node("TowerDescription").text  = generate_description()
	var op_button = details_parent.get_node("TargetingOptionButton") as OptionButton
	
	if tower.is_aoe:
		if op_button.item_count < 3:
			op_button.add_item("Spot", 2)
	else:
		if op_button.item_count > 2:
			op_button.remove_item(2)
			
	details_parent.get_node("TowerSetSpotButton").visible = tower.is_aoe and op_button.selected == 2
	details_parent.get_node("TowerSellButton/TowerSellCostContainer/Label").text = str(tower.get_refund_price())
	
	var cost = tower.get_upgrade_cost(tower_instance.range_upgrade + tower_instance.duration_upgrade)
	
	if cost == null:
		details_parent.get_node("UpgradeContainer/Label").text = "Upgrade Cost: Maxed"
		details_parent.get_node("UpgradeContainer/HBoxContainer").visible = false
	else:
		details_parent.get_node("UpgradeContainer/HBoxContainer").visible = true
		details_parent.get_node("UpgradeContainer/Label").text = "Upgrade Cost: " + str(tower.get_upgrade_cost(tower_instance.range_upgrade + tower_instance.duration_upgrade)) + "\t(" + str(tower_instance.range_upgrade + tower_instance.duration_upgrade) + " out of " + str(tower.upgrade_cost_multipliers.size()) + ")"
		if not game.can_buyi(cost):
			details_parent.get_node("UpgradeContainer/HBoxContainer/RangeUpgradeButton").disabled = true
			details_parent.get_node("UpgradeContainer/HBoxContainer/DurationUpgradeButton").disabled = true
		else:
			details_parent.get_node("UpgradeContainer/HBoxContainer/RangeUpgradeButton").disabled = false
			details_parent.get_node("UpgradeContainer/HBoxContainer/DurationUpgradeButton").disabled = false
	pass

func generate_description() -> String:
	var format_string = "Element: %s\n\nType:%s\nDamage: %s\nAttack Duration: %s"
	return format_string % [tower.element.display_name, "AOE" if tower.is_aoe else "Single Target", tower.damage, tower_instance.get_duration()]
	
func unset_tower() -> void:
	tower = null
	tower_instance = null
	details_parent.visible = false
	pass

func confirm_spot(spot):
	if (spot == null) or (spot != null and (spot - tower_instance.global_position).length() < tower_instance.get_range()):
		tower_instance.set_spot(spot)
		details_parent.get_node("TowerSetSpotButton").set_toggle(false)
		print("Spot %s was selected" % spot)	
		return true
	else:
		return false

func _on_targeting_option_button_item_selected(index):
	details_parent.get_node("TowerSetSpotButton").visible = tower.is_aoe and index == 2
	tower_instance.targeting_category = index
	pass # Replace with function body.

func _on_tower_set_spot_button_pressed():
	if tower != null:
		if not details_parent.get_node("TowerSetSpotButton")._toggled:
			spot_selector.start_spot_selection(tower.aoe_range)
		else: 
			spot_selector.end_spot_selection(null)
		pass # Replace with function body.
	pass # Replace with function body.


func _on_tower_sell_button_pressed():
	tower_instance.refund()
	unset_tower()
	pass # Replace with function body.


func _on_duration_upgrade_button_pressed():
	tower_instance.apply_upgrade(1,0)
	pass # Replace with function body.


func _on_range_upgrade_button_pressed():
	tower_instance.apply_upgrade(0,1)
	pass # Replace with function body.


func _on_game_currency_changed(new_value):
	if tower_instance != null:
		set_tower(tower_instance)
	pass # Replace with function body.
