extends Node

@export var ticks_per_turn = 10

var tick = 0
var wave = 0

var time = 0

var tick_registration : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in ticks_per_turn:
		tick_registration[i] = null
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	# 1 second clock
	if time > 1:
		do_tick(tick % 10)
		tick += 1
		time = 0
	pass
	
func do_tick(tick): 
	print('tick')
	# Enemy effects
	
	# Activate Towers / Towers Fire
	print(tick_registration[tick])
	
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
	
func register_tower(tick, tower):
	tick_registration[tick] = tower
