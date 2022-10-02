extends Reaction

@export var aoe_range : int = 50
@export var element : Element
@export var aoe : PackedScene

func apply_death_effect(enemy: Enemy):
	super.apply_death_effect(enemy)
	
	var new_aoe = aoe.instantiate()
	
	new_aoe.element = element
	new_aoe.radius = aoe_range
	new_aoe.lifetime = 1
	
	enemy.get_node("/root/Game/Map").add_child(new_aoe)
	
	
