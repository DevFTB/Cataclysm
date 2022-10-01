extends Node2D

@export var enemies : Array[PackedScene]
@export var spawn_register = [[{0 : 5}, {0 : 2}, {0 : 1}, {0 : 4}],[],[],[]]
@export var spawn_delay = 0.5

var paths = []
var spawned_enemies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print($Paths.get_children())
	paths = $Paths.get_children()
	spawn_wave(0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func spawn_wave (wave: int) -> void:
	var wave_data = spawn_register[wave]
	
	for i in range(paths.size()):
		var path_data = wave_data[i]
		for enemy_type in path_data.keys():
			for j in range(path_data[enemy_type]):
				spawned_enemies.append(spawn_enemy(enemies[enemy_type], i))
				await get_tree().create_timer(spawn_delay).timeout
		
		

func spawn_enemy(enemy : PackedScene, path_id: int) -> void:
	var new_enemy = enemy.instantiate()
	$Paths.get_child(path_id).add_child(new_enemy)
	
	return new_enemy

