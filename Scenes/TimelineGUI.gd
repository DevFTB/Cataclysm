extends Control

@export var timeline_list_item : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_highlight_for_tick(tick):
	for child in $ScrollContainer/ListItemParent.get_children():
		if child.tick == tick:
			print(str(child.tick) + ", " + str(tick))
			child.set_highlight(true)
		else:
			child.set_highlight(false)
	pass
	
func regenerate_list():
	for child in $ScrollContainer/ListItemParent.get_children():
		child.queue_free()
		
	var tick_registration = get_node("/root/Game").tick_registration
	
	for tick in tick_registration:
		var item = timeline_list_item.instantiate()
		
		var item_at_tick = tick_registration[tick]
		
		if item_at_tick != null:
			item.set_details(item_at_tick, tick)
		else:
			item.init_empty()
		$ScrollContainer/ListItemParent.add_child(item)
