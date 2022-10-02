extends Reaction
class_name AoEReaction

@export var aoe_range : int = 50
@export var element : Element
@export var aoe : PackedScene

func on_start(enemy: Enemy):
	super.on_start(enemy)
	
	var new_aoe = aoe.instantiate()
	
	new_aoe.element = element
	new_aoe.radius = aoe_range
	new_aoe.lifetime = duration
	
	enemy.get_node("/root/Game/Map").add_child(new_aoe)
	
	
