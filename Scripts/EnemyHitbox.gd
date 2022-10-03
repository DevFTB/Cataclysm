extends Area2D


func get_enemy():
	return get_parent().get_parent()
