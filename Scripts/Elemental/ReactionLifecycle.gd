extends Node
class_name ReactionLifecycle

var reaction : Reaction

@onready var enemy = get_parent().get_parent()

var tick_counter = 0
func _ready():
	reaction.on_start(enemy)

func tick():
	reaction.apply_tick_effect(enemy)
	

	if tick_counter >= reaction.duration:
		reaction.on_end(enemy)
		queue_free()
		return
	
	tick_counter += 1
