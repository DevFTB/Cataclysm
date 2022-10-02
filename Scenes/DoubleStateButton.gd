extends Button

@export var _toggled = false

@export var toggled_text  = ""
@export var not_toggled_text = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", _on_pressed)
	pass # Replace with function body.

func _on_pressed():
	_toggled = !_toggled
	text = toggled_text if _toggled else not_toggled_text
	pass

func set_toggle(toggle):
	_toggled = toggle
	text = toggled_text if _toggled else not_toggled_text
