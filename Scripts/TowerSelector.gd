extends Control

@export var button_parent : NodePath
@export var button_scene : PackedScene
@export var towers : Array[PackedScene]

enum Clan {
	GREWT, KHANOVIAN, THE_ORDER
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for tower in towers:
		var packed_state = tower.get_state()
		for node_idx in packed_state.get_node_count():
			var node_name = packed_state.get_node_name(node_idx)
			if node_name == "Tower":
				var tower_name = ""
				var ui_image : Texture2D
				var clan : Clan
				for node_prop_idx in packed_state.get_node_property_count(node_idx):
					var prop_name = packed_state.get_node_property_name(node_idx, node_prop_idx)
					var prop_value = packed_state.get_node_property_value(node_idx, node_prop_idx)
					if prop_name == "tower_name":
						tower_name = prop_value
					if prop_name == "ui_image":
						ui_image = prop_value
					if prop_name == "clan":
						clan = prop_value
						
				instance_button(tower, tower_name, ui_image, clan)
	
	for button in get_node(button_parent).get_children():
		button.visible = false
	pass # Replace with function body.

func instance_button(tower, tower_name, ui_image, clan):
	var new_button = button_scene.instantiate()
	
	new_button.icon = ui_image
	new_button.text = tower_name
	new_button.tower = tower
	new_button.clan = clan
	
	get_node(button_parent).add_child(new_button)
	get_node(button_parent).queue_sort()

	pass
	
func select_tower(tower: PackedScene, ui_image: Texture2D):
	get_node("/root/Game/TowerPlacer").set_tower_placement(tower,  ui_image)
	pass

func switch_clan_view(clan):
	for button in get_node(button_parent).get_children():
		button.visible = button.clan == clan

func _on_grewt_tower_button_pressed():
	switch_clan_view(Clan.GREWT)
	pass # Replace with function body.


func _on_khanovian_tower_button_pressed():
	switch_clan_view(Clan.KHANOVIAN)
	pass # Replace with function body.


func _on_the_order_tower_button_pressed():
	switch_clan_view(Clan.THE_ORDER)
	pass # Replace with function body.


func _on_minimise_button_toggled(button_pressed):
	$VBoxContainer/Control.visible = button_pressed
	pass # Replace with function body.
