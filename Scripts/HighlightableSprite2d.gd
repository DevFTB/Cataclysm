extends Sprite2D

@export var highlight_shader : ShaderMaterial
	
func set_highlight(value):
	if value:
		material = highlight_shader 
	else:
		material = null
