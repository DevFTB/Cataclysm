extends Node2D



var can_place : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_viewport().get_mouse_position()
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("target"):
			print(can_place)


func _on_placeable_area_can_place_changed(can_place):
	self.can_place = can_place
	pass # Replace with function body.
