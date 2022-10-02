extends Button

@export var toggled_text  = ""
@export var not_toggled_text = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("toggled", _on_toggled)
	_on_toggled(button_pressed)
	pass # Replace with function body.

func _on_toggled(_button_pressed):
	text = toggled_text if _button_pressed else not_toggled_text
