extends Node

@export var ticks_per_turn = 10

signal paused
signal resumed

var game_over = false
var autoplay = false

var game_paused = true

var tick = 0
var turn = 0
var time = 0
var tick_registration : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in ticks_per_turn:
		tick_registration[i] = null
		
	$GUI/TimelineGUI.regenerate_list()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if time > 1:
		time = 0
		
		if not game_paused and (tick >= 0 and tick < ticks_per_turn):
			do_tick(tick)
			tick += 1
				
		if not game_paused and tick >= ticks_per_turn:
			if autoplay:
				new_turn()
			else:
				emit_signal("paused")
				game_paused = true
		
	if game_paused:
		pass

	pass
	
func new_turn():
	tick = 0
	turn += 1
	
	game_paused = false
	emit_signal("resumed")
	print("new turn")
	pass
	
func do_tick(tick): 
	print('tick')
	# Enemy effects
	
	# Activate Towers / Towers Fire
	print(tick_registration[tick])
	$GUI/TimelineGUI.set_highlight_for_tick(tick)
	# Deal base damage and kill enemies
	
	# Apply 1U of element to enemies
	
	# Elemental Reactions happens
	
	# Calculate new health and kill enemies
	
	# Deactivate tower effects
	pass
	
func auto_register_tower(tower):
	for tick in tick_registration.keys():
		if tick_registration[tick] == null:
			tick_registration[tick] = tower
			break
	$GUI/TimelineGUI.regenerate_list()
	
func swap_tower_to(src_tick, dest_tick):
	var old = tick_registration[dest_tick]
	var new = tick_registration[src_tick]
	tick_registration[dest_tick] = new
	tick_registration[src_tick] = old
	$GUI/TimelineGUI.regenerate_list()
	
func register_tower(tick, tower):
	tick_registration[tick] = tower
	$GUI/TimelineGUI.regenerate_list()


func _on_pause_play_button_pressed():
	if game_paused:
		new_turn()
	pass # Replace with function body.


func _on_autoplay_button_toggled(button_pressed):
	autoplay = button_pressed
	pass # Replace with function body.
