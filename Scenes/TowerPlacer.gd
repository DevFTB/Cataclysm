extends Node2D

@export var tower : PackedScene
@export var tower_parent : NodePath

@onready var game = get_node("/root/Game")
@onready var max_towers = game.ticks_per_turn

var in_placeable_area : bool = false
var obstructed : bool  = false

var towers_active = 0

# Select mode = 0, tower_placement = 1 , spot_selection
var mode = 0

var tower_selection : Node2D
var tower_selection_candidate : Node2D

var should_draw_aoe = false
var draw_aoe = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	game.get_node("Map/PlaceableArea").connect("can_place_changed", _on_placeable_area_can_place_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_viewport().get_mouse_position()
	pass

func _input(event):
	if event is InputEventMouseButton:
		print("mode is %s" % mode)
		if mode == 0:
			if event.is_action_pressed("select"):
				if tower_selection_candidate != null:
					select_tower()
					
			pass
			if event.is_action_pressed("cancel"):
				deselect_tower()

				pass
		if mode == 1:
			if event.is_action_pressed("select"):
				if can_place():
					place_tower()
			if event.is_action_pressed("cancel"):
				if tower != null:
					unset_tower_placement()
		if mode == 2:
			if event.is_action_pressed("select"):
				end_spot_selection(event.global_position)
			if event.is_action_pressed("cancel"):
				end_spot_selection(null)
				
func end_spot_selection(spot):
	if game.get_node("GUI/TowerGUI").confirm_spot(spot):
		mode = 0
		should_draw_aoe = false
		queue_redraw()
	
func start_spot_selection(aoe: int):
	mode = 2
	should_draw_aoe = true
	draw_aoe = aoe
	queue_redraw()

func _draw():
	if should_draw_aoe:
		draw_circle(Vector2(0,0), draw_aoe, Color(Color.CHARTREUSE, 0.1))

func select_tower() -> void:
	deselect_tower()
	tower_selection = tower_selection_candidate
	tower_selection.set_highlight(true)
	print("%s was selected. " % tower_selection)
	
	game.get_node("GUI/TowerGUI").set_tower(tower_selection)
	pass
	
func deselect_tower() -> void:
	if tower_selection != null:
		tower_selection.set_highlight(false)
		tower_selection = null
		
	game.get_node("GUI/TowerGUI").unset_tower()
	pass

func can_place() -> bool:
	var location_good = in_placeable_area and not obstructed
	var tower_good = tower != null and towers_active < max_towers
	
	return location_good and tower_good and game.game_paused

func place_tower():
	var new_tower = tower.instantiate() as Node2D
	game.get_node("Map/Towers").add_child(new_tower)

	new_tower.position = get_viewport().get_mouse_position()
	new_tower.connect("mouse_entered", func() : on_Tower_mouse_entered(new_tower))
	new_tower.connect("mouse_exited", func() : on_Tower_mouse_exited(new_tower))
	
	game.auto_register_tower(new_tower)
	
	$AudioStreamPlayer.play()
	towers_active += 1

func set_tower_placement(tower: PackedScene, icon: Texture2D) -> void:
	self.tower = tower
	$GhostIcon.texture = icon
	$GhostIcon.visible = true
	
	mode = 1
	
func unset_tower_placement():
	self.tower = null
	$GhostIcon.visible = false
	
	mode = 0

func _on_placeable_area_can_place_changed(can_place):
	self.in_placeable_area = can_place
	pass # Replace with function body.

func on_Tower_mouse_entered(src):
	self.obstructed = true
	self.tower_selection_candidate = src
	pass
func on_Tower_mouse_exited(src):
	self.obstructed = false
	self.tower_selection_candidate = null
	pass
