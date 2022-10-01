extends Node2D

var paths = []
@export var enemies = {}
@export var spawn_register = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	
	print($Paths.get_children())
	paths = $Paths.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy(enemy : PackedScene, path_id: int) -> void:
	$Paths.get_child(path_id).add_child(enemy.instantiate())
	pass

