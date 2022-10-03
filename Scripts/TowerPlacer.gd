extends Node2D

@export var tower_scene : PackedScene

@onready var game = get_node("/root/Game")
@onready var max_towers = game.ticks_per_turn

var tower_parent : NodePath
var placement_tower : Tower
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
func _process(_delta):
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
				if placement_tower != null:
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
	if mode == 1:
		draw_circle(Vector2(0,0), placement_tower.attack_range, Color(Color.CHARTREUSE, 0.1))
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
	var tower_good = placement_tower != null and towers_active < max_towers
	var has_moneys = game.can_buy(placement_tower)
	
	return location_good and tower_good and game.game_paused and has_moneys

func place_tower():
	game.spend_currency(placement_tower.currency_cost)
	
	var new_tower = tower_scene.instantiate()
	new_tower.tower = placement_tower
	game.get_node("Map/Towers").add_child(new_tower)

	new_tower.position = get_viewport().get_mouse_position()
	new_tower.connect("mouse_entered", func() : on_Tower_mouse_entered(new_tower))
	new_tower.connect("mouse_exited", func() : on_Tower_mouse_exited(new_tower))
	
	game.auto_register_tower(new_tower)
	
	$AudioStreamPlayer.play()
	towers_active += 1

func set_tower_placement(tower: Tower, icon: Texture2D) -> void:
	placement_tower = tower
	$GhostIcon.texture = icon
	$GhostIcon.visible = true
	
	mode = 1
	queue_redraw()
	
func unset_tower_placement():
	placement_tower = null
	$GhostIcon.visible = false
	
	mode = 0
	queue_redraw()

func _on_placeable_area_can_place_changed(placeable):
	in_placeable_area = placeable
	pass # Replace with function body.

func on_Tower_mouse_entered(src):
	obstructed = true
	tower_selection_candidate = src
	pass
func on_Tower_mouse_exited(_src):
	obstructed = false
	tower_selection_candidate = null
	pass
