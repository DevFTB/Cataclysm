extends HBoxContainer

var tick = -1
var tower
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init_empty():
	$TextureRect.texture = null
	$TickLabel.text = " "
	
	$UpDownButtons.visible = false

func set_details(tower, tick):
	self.tower = tower
	$TowerNameLabel.text = tower.tower_name
	
	$TextureRect.texture = tower.ui_image
	
	self.tick = tick
	$TickLabel.text = str(tick + 1)
	
	$UpDownButtons.visible = true
	
	if tick == 0:
		$UpDownButtons/UpButton.disabled = true
		
	if tick == 9:
		$UpDownButtons/DownButton.disabled = true


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
