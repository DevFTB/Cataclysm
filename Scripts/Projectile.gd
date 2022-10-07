extends Area2D

var target_entity : Node2D
var element: Element
var damage = 0

@export var timeout = 3
@export var speed = 500

var timer = 0

@onready var game = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2d.texture = element.projectile_texture
	connect("area_entered", _on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game.game_paused and target_entity != null:
		timer += delta
		global_position += (target_entity.global_position - global_position).normalized() * speed * delta
		if timer > timeout:
			queue_free()
	pass
	
func _on_area_entered(area: Area2D) -> void:
	var enemy = area.get_enemy() as Enemy
	
	enemy.take_damage(damage, element)
	queue_free()
	pass
