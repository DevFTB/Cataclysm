extends Area2D

enum Element {
	WATER, AIR, EARTH, FIRE, ELECTRICITY, STEEL, DARK, LIGHT
}

@export var max_health : int = 50
@export var enemy_name : String = "Enemy"

@export var resistances : Dictionary

@onready var health = max_health
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_resistances(damage: int, element: Element) -> void:
	pass

func take_damage(damage: int, element: Element) -> void:
	
	var true_damage = apply_resistances(damage, element)
	
	health -= damage
	if health < 0:
		die()
	pass

func die():
	pass
