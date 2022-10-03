extends Resource
class_name Reaction

@export var element1 : Element
@export var element2 : Element
@export var display_name : String

@export var duration : int  = 1
@export_color_no_alpha var colour : Color = Color.WHITE

@export var resistance_modifier : ResistanceSet
@export var move_speed_modifier : float = 1
@export var attack_modifier : float = 1

func _init(p_e1 = null, p_e2 = null, p_display_name =""):
	element1 = p_e1
	element2 = p_e2
	display_name = p_display_name

func on_start(enemy: Enemy):
	enemy.apply_move_speed_modifier(move_speed_modifier)
	enemy.apply_attack_modifier(attack_modifier)
	pass

func apply_tick_effect(enemy: Enemy):
	if resistance_modifier != null:
		enemy.apply_resistance_modifier(resistance_modifier)
	
	pass

func on_end(enemy: Enemy):
	enemy.remove_move_speed_modifier(move_speed_modifier)
	enemy.remove_attack_modifier(attack_modifier)
	pass
	
func apply_death_effect(_enemy: Enemy):
	pass

func match_elements(e1: Element, e2: Element) -> bool:
	return (e1 == element1 and e2 == element2) or (e1 == element2 and e2 == element1)
