extends Node2D

@export var tower : PackedScene
@export var tower_parent : NodePath

var in_placeable_area : bool = false
var obstructed : bool  = false

var towers_active = 0
@onready var max_towers = get_node("/root/Game").ticks_per_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Game/Map/PlaceableArea").connect("can_place_changed", _on_placeable_area_can_place_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_viewport().get_mouse_position()
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("target"):
			if can_place():
				place_tower()

func can_place() -> bool:
	var location_good = in_placeable_area and not obstructed
	var tower_good = tower != null and towers_active < max_towers
	
	return location_good and tower_good and get_node("/root/Game").game_paused

func place_tower():
	var new_tower = tower.instantiate() as Node2D
	get_node(tower_parent).add_child(new_tower)

	new_tower.position = get_viewport().get_mouse_position()
	new_tower.connect("mouse_entered", on_Tower_mouse_entered)
	new_tower.connect("mouse_exited", on_Tower_mouse_exited)
	
	get_node("/root/Game").auto_register_tower(new_tower)
	
	get_node("AudioStreamPlayer").play()
	towers_active += 1

func _on_placeable_area_can_place_changed(can_place):
	self.in_placeable_area = can_place
	pass # Replace with function body.

func on_Tower_mouse_entered():
	self.obstructed = true
	pass
func on_Tower_mouse_exited():
	self.obstructed = false
	pass
