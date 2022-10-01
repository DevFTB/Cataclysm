extends Control

var tick = -1
var tower
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_highlight(value):
	$TurnColorRect.visible = value
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init_empty():
	
	$HBoxContainer/TextureRect.texture = null
	$HBoxContainer/TickLabel.text = " "
	
	$HBoxContainer/UpDownButtons.visible = false

func set_details(tower, tick):
	self.tower = tower
	$HBoxContainer/TowerNameLabel.text = tower.tower_name
	
	$HBoxContainer/TextureRect.texture = tower.ui_image
	
	self.tick = tick
	$HBoxContainer/TickLabel.text = str(tick + 1)
	
	$HBoxContainer/UpDownButtons.visible = true
	
	if tick == 0:
		$HBoxContainer/UpDownButtons/UpButton.disabled = true
		
	if tick == 9:
		$HBoxContainer/UpDownButtons/DownButton.disabled = true


func _on_up_button_pressed():
	get_node("/root/Game").swap_tower_to(tick, tick - 1)
	pass # Replace with function body.


func _on_down_button_pressed():
	get_node("/root/Game").swap_tower_to(tick, tick + 1)
	pass # Replace with function body.


func _on_timeline_tower_list_item_mouse_entered():
	if tower != null:
		tower.set_highlight(true)
	pass # Replace with function body.


func _on_timeline_tower_list_item_mouse_exited():
	if tower != null:
		tower.set_highlight(false)
	pass # Replace with function body.
