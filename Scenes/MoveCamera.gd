extends Camera2D

@export var scaling = 10

var toggled = false
@export var bounds = Rect2i(-500, -500, 1000,1000)
@export var min_zoom = 1.3
@export var max_zoom = 0.8
@export var zoom_increment = 0.05
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("move_camera"):
			toggled = true
		elif event.is_action_released("move_camera"):
			toggled = false
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					var val = min(max_zoom, zoom_increment + zoom.x)
					zoom = Vector2(val,val)
				MOUSE_BUTTON_WHEEL_DOWN:
					var val = max(min_zoom, zoom_increment - zoom.x)
					zoom = Vector2(val,val)
	elif event is InputEventMouseMotion:
		if toggled:
			var candidate = position - event.relative * scaling
			position -= event.relative * scaling
