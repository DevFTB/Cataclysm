extends Node2D

@export var tower : PackedScene
@export var tower_parent : NodePath

var can_place : bool = false
var obstructed : bool  = false
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
			if can_place and not obstructed and tower != null:
				place_tower()

func place_tower():
	var new_tower = tower.instantiate() as Node2D
	get_node(tower_parent).add_child(new_tower)

	new_tower.position = get_viewport().get_mouse_position()
	new_tower.connect("mouse_entered", on_Tower_mouse_entered)
	new_tower.connect("mouse_exited", on_Tower_mouse_exited)
	
	get_node("AudioStreamPlayer").play()

func _on_placeable_area_can_place_changed(can_place):
	self.can_place = can_place
	pass # Replace with function body.

func on_Tower_mouse_entered():
	self.obstructed = true
	pass
func on_Tower_mouse_exited():
	self.obstructed = false
	pass
