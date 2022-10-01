extends Control

@export var button_parent : NodePath
@export var button_scene : PackedScene
@export var towers : Array[PackedScene]


# Called when the node enters the scene tree for the first time.
func _ready():
	for tower in towers:
		var packed_state = tower.get_state()
		for node_idx in packed_state.get_node_count():
			var node_name = packed_state.get_node_name(node_idx)
			print("node_name=", node_name)
			if node_name == "Tower":
				var tower_name = ""
				var ui_image : Texture2D
				for node_prop_idx in packed_state.get_node_property_count(node_idx):
					var prop_name = packed_state.get_node_property_name(node_idx, node_prop_idx)
					print ("  node_prop_name=", )
					var prop_value = packed_state.get_node_property_value(node_idx, node_prop_idx)
					print ("  node_value=", prop_value)
					if prop_name == "tower_name":
						tower_name = prop_value

					if prop_name == "ui_image":
						ui_image = prop_value
						
				instance_button(tower, tower_name, ui_image)
				
	pass # Replace with function body.

func instance_button(tower, tower_name, ui_image):
	var new_button = button_scene.instantiate()
	
	new_button.icon = ui_image
	new_button.text = tower_name
	new_button.tower = tower
	
	get_node(button_parent).add_child(new_button)
	get_node(button_parent).queue_sort()

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func select_tower(tower: PackedScene):
	get_node("/root/Game/TowerPlacer").tower = tower
	pass
