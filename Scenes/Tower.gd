extends Area2D
class_name Tower

enum TargetingCategory {
	FIRST, STRONG, SPOT
}

@export var tower_name : String
@export var ui_image : Texture2D
@export var clan : Game.Clan
@export var element : Game.Element

@export var damage = 100
@export var attack_duration = 3
@export var attack_range = 400

@export var targeting_category = TargetingCategory.FIRST
@export var is_aoe = false

var drawing_range_circle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_highlight(value):
	$Sprite2d.set_highlight(value)
	drawing_range_circle = value
	queue_redraw()
		
func _draw():
	if drawing_range_circle:
		draw_circle(Vector2.ZERO, attack_range, Color(Color.CHARTREUSE, 0.1))
		
