extends Sprite2D

@export var desired_size : Vector2 = Vector2(64,64)
@export var highlight_shader : ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready():
	update_size()
	pass # Replace with function body.

func update_size():
	if texture != null:
		scale = desired_size / texture.get_size()

	
func set_highlight(value):
	if value:
		material = highlight_shader 
	else:
		material = null
