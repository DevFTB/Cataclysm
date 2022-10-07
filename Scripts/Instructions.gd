extends Control


func _on_minimise_button_toggled(button_pressed):
	$Control.visible = button_pressed
