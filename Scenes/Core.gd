extends Area2D

@export var max_health = 10

signal core_damage_taken(new_health: int)
signal core_destroyed

@onready var health = max_health
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_core_area_entered(area):
	take_damage(1)
	$AudioStreamPlayer2d.play()
	area.get_enemy().die()
	pass # Replace with function body.

func take_damage(damage: int):
	health -= damage
	emit_signal("core_damage_taken", health)
	
	$CoreHPBar.set_value(float(health) / float(max_health) * 100)
	
	if health <= 0:
		emit_signal("core_destroyed")
