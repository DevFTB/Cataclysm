extends Node
class_name ReactionLifecycle

var reaction : Reaction

@onready var enemy = get_parent().get_parent()

var tick_counter = 0
func _ready():
	reaction.on_start(enemy)

func tick():
	if reaction.duration > 0:
		enemy.create_reaction_text(reaction)
		reaction.apply_tick_effect(enemy)
	tick_counter += 1

func try_free():
	if tick_counter >= reaction.duration:
		reaction.on_end(enemy)
		queue_free()

func apply_death_effects():
	reaction.apply_death_effect(enemy)
	
