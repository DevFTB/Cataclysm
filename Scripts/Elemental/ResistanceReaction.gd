extends Reaction



func apply_effect(enemy: Enemy):
	enemy.apply_resistance_modifier(resistance_modifier)
