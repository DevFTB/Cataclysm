extends Control

@export var game_scene : PackedScene

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(game_scene)
	pass # Replace with function body.
