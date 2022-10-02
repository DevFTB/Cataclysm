extends Control

@export var timeline_list_item : PackedScene
@export var item_parent_path : NodePath
@onready var item_parent = get_node(item_parent_path)

func set_highlight_for_tick(tick):
	for child in item_parent.get_children():
		if child.tick == tick:
			child.set_highlight(true)
		else:
			child.set_highlight(false)
	pass
	
func regenerate_list():
	for child in item_parent.get_children():
		child.queue_free()
		
	var tick_registration = get_node("/root/Game").tick_registration
	
	for tick in tick_registration:
		var item = timeline_list_item.instantiate()
		
		var item_at_tick = tick_registration[tick]
		
		if item_at_tick != null:
			item.set_details(item_at_tick, tick)
		else:
			item.init_empty()
		item_parent.add_child(item)


func _on_minimise_button_toggled(button_pressed):
	$VSplitContainer/Control.visible = button_pressed

	pass # Replace with function body.
