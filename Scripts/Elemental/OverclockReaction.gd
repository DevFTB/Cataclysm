extends Reaction

@export var aoe_range : int = 50
@export var element : Element
@export var aoe : PackedScene
@export var aoe_damage = 300

func apply_death_effect(enemy: Enemy):
	super.apply_death_effect(enemy)
	var new_aoe = aoe.instantiate()
	
	new_aoe.damage = aoe_damage
	new_aoe.element = element
	new_aoe.radius = aoe_range
	new_aoe.lifetime = 1
	
	new_aoe.global_position = enemy.global_position
	new_aoe.colour_override = element.colour
	
	enemy.get_node("/root/Game/Map").add_child(new_aoe)
	
	
