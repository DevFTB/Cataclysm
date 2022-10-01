extends Sprite2D

@export var highlight_shader : ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_highlight(value):
	print("set highlight" + str(value))
	if value:
		material = highlight_shader 
	else:
		material = null
