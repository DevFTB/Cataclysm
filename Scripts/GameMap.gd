extends Node2D

@export var enemies : Array[EnemyStats]
@export var spawn_register = [[{0: 1, 1: 0}, {} ,{}, {}]] #[[{0 : 3, 1 : 1}, {0 : 2}, {0 : 1}, {0 : 4}],[{},{},{},{}],[{},{},{},{}],[{},{},{},{}]]
@export var spawn_delay = 0.5
@export var max_time_till_next_wave = 5


@onready var game = get_node("/root/Game")

var paths = []
var spawned_enemies = []

var rng = RandomNumberGenerator.new()

var time_till_next_wave = 0

var wave_no = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	paths = $Paths.get_children()
	time_till_next_wave = 0
	pass # Replace with function body.

var time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game.game_paused:
		time += delta
	
	if time > time_till_next_wave:
		spawn_wave(wave_no)
		time_till_next_wave = rng.randf_range(float(max_time_till_next_wave) * 2 / 3, max_time_till_next_wave)
		wave_no+=1
		time = 0 
	pass
	
func spawn_wave (wave: int) -> void:
	print('spawning new wave')
	var wave_data = spawn_register[wave % spawn_register.size()]
	
	for i in range(paths.size()):
		var path_data = wave_data[i]
		for enemy_type in path_data.keys():
			for j in range(path_data[enemy_type]):
				spawned_enemies.append(spawn_enemy(enemies[enemy_type], i))
				await get_tree().create_timer(spawn_delay).timeout
		

func spawn_enemy(stats : EnemyStats, path_id: int) -> void:
	var new_enemy = Enemy.new()
	new_enemy.stats = stats
	
	$Paths.get_child(path_id).add_child(new_enemy)
	
	return new_enemy

