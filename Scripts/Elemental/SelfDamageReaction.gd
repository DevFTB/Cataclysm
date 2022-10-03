extends Reaction
class_name SelfDamageReaction

@export var self_damage : int = 10
@export var self_damage_element : Element

func apply_tick_effect(enemy: Enemy):
	super.apply_tick_effect(enemy)
	
	enemy.take_damage(self_damage, self_damage_element)
	pass
