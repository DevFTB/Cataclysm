extends HBoxContainer


func show_elements(elements: Array[Element]):
	for child in get_children():
		child.queue_free()
		
	for e in elements:
		var texture_rect = TextureRect.new()
		
		texture_rect.texture = e.icon
		texture_rect.custom_minimum_size = Vector2(16, 16)
		texture_rect.ignore_texture_size = true
		texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		add_child(texture_rect)
