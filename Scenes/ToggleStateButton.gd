extends Button

@export var toggled_text  = ""
@export var not_toggled_text = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("toggled", _on_toggled)
	_on_toggled(button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_toggled(button_pressed):
	text = toggled_text if button_pressed else not_toggled_text
