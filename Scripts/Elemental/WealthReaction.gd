extends Reaction

@export var currency_multiplier : float  = 2

func apply_death_effect(_enemy: Enemy):
	super.apply_death_effect(_enemy)
	_enemy.currency_multiplier += currency_multiplier
	pass
