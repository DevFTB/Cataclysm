extends Area2D

var target : Vector2
var element: Element
var damage = 0
@export var speed = 150

@onready var game = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game.game_paused:
		global_position += (target - global_position).normalized() * speed * delta
		if(target - global_position).length() < 1:
			queue_free()
	pass
	
func _on_area_entered(area: Area2D) -> void:
	var enemy = area.get_enemy() as Enemy
	
	enemy.take_damage(damage, element)
	queue_free()
	pass
