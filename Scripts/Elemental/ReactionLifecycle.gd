extends Node
class_name ReactionLifecycle

var reaction : Reaction

@onready var enemy = get_parent().get_parent()

var tick_counter = 0
func _ready():
	reaction.on_start(enemy)

func tick():
	if tick_counter >= reaction.duration:
		reaction.on_end(enemy)
		queue_free()
		return
	
	reaction.apply_effect(enemy)
	
	tick_counter += 1
