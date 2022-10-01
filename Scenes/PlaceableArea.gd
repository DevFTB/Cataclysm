extends Node2D

signal can_place_changed(can_place : bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	
	for child in children:
		child.connect("mouse_entered", on_Child_mouse_entered)
		child.connect("mouse_exited", on_Child_mouse_exited)
	pass # Replace with function body.

func on_Child_mouse_entered():
	emit_signal("can_place_changed", true)
	pass
func on_Child_mouse_exited():
	emit_signal("can_place_changed", false)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
