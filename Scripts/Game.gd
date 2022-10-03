extends Node
class_name Game

@export var ticks_per_turn = 10
@export var reactions : Array[Reaction]
@export var starting_currency = 5
enum Clan {
	GREWT, KHANOVIAN, THE_ORDER
}

@onready var tower_parent  = $Map/Towers

signal paused
signal resumed

signal currency_changed(new_value: int)

var game_over = false
var autoplay = false

var game_paused = true

var current_tick = 0
var turn = 0
var time = 0
var tick_registration : Dictionary = {}

var currency = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in ticks_per_turn:
		tick_registration[i] = null
		
	$GUI/TimelineGUI.regenerate_list()
	
	get_node("Map").connect("cores_dead", _on_cores_dead)
	
	add_to_currency(starting_currency)
	$ActionMusic.play()
	$ActionMusic.stream_paused = true
	
	$AmbientMusic.play()
	pass # Replace with function body.

func _on_cores_dead():
	set_game_over()

func set_game_over():
	game_over = true
	$GUI.visible = false
	$GameOver.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not game_over:
		time += delta
		
		if time > 1:
			time = 0
			
			if not game_paused and (current_tick >= 0 and current_tick < ticks_per_turn):
				do_tick(current_tick)
				current_tick += 1
					
			if not game_paused and current_tick >= ticks_per_turn:
				if autoplay:
					new_turn()
				else:
					emit_signal("paused")
					game_paused = true
					$ActionMusic.stream_paused = true
					$AmbientMusic.stream_paused = false
		if game_paused:
			pass

	pass
	
func new_turn():
	current_tick = 0
	turn += 1
	
	game_paused = false
	emit_signal("resumed")
	print("new turn")
	$ActionMusic.stream_paused = false
	$AmbientMusic.stream_paused = true
	
func do_tick(tick): 
	$GUI/TickTimer.text = str(tick + 1)
	print('tick')
	# 1. Activate towers 
	var tower_to_activate = tick_registration[tick]
	if tower_to_activate != null:
		tower_to_activate.activate()
		
	# 2. Fire towers
	tick_towers(tick)
	tick_aoe()
	
	# 3. Deactivate tower effects
	
	# 4. Apply Elements to Enemy => Generate Reactions <-- POST-TOWER PHASE
	# 5. Deal modified damaged  (dmg * resistances * reaction_multipliers)
	# 6. Check dead and do post-dead reactions <-- POST-DEAD PHASE
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		enemy.tick()
	
	pass

func tick_aoe():
	var aoes = get_tree().get_nodes_in_group("aoe")
	
	for aoe in aoes:
		aoe.tick()

func tick_towers(tick) -> void:
	$GUI/TimelineGUI.set_highlight_for_tick(tick)
	
	for tower in tick_registration.values():
		if tower != null:
			tower.tick()
	
func auto_register_tower(tower):
	for tick in tick_registration.keys():
		if tick_registration[tick] == null:
			tick_registration[tick] = tower
			break
	on_update_registration()
	
func swap_tower_to(src_tick, dest_tick):
	var old = tick_registration[dest_tick]
	var new = tick_registration[src_tick]
	tick_registration[dest_tick] = new
	tick_registration[src_tick] = old
	on_update_registration()
	
func register_tower(tick, tower):
	tick_registration[tick] = tower
	on_update_registration()
	
func unregister_tower(tower):
	var tick = tick_registration.find_key(tower)
	if tick != null:
		$TowerPlacer.towers_active -= 1
		tick_registration[tick] = null
	
func on_update_registration():
	$GUI/TimelineGUI.regenerate_list()
	for tick in tick_registration.keys():
		if tick_registration[tick]:
			tick_registration[tick].set_tick(tick)
	pass
	
func get_reaction(elements: Array[Element]):
	if elements.size() >  2:
		return reactions[0]
	else:
		var e1 = elements[0]
		var e2 = elements[1]
		for r in reactions:
			if r.match_elements(e1, e2):
				return r
	
	return reactions[0]

func can_buy(tower: Tower) -> bool:
	return tower.currency_cost <= currency 

func spend_currency(amount: int) -> void:
	currency -= amount
	emit_signal("currency_changed", currency)

func add_to_currency(amount: int) -> void:
	currency += amount
	emit_signal("currency_changed", currency)

func _on_pause_play_button_pressed():
	if game_paused:
		new_turn()
	pass # Replace with function body.


func _on_autoplay_button_toggled(button_pressed):
	autoplay = button_pressed
	pass # Replace with function body.


func _on_play_button_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.
