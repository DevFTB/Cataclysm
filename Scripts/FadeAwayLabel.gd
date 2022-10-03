extends Label
class_name FadeAwayLabel

@export var initial_color : Color
@export var burn_away_time : float
@export var vertical_displacement : float
var tween : Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = initial_color
	tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(self, "modulate", Color(0,0,0,0), burn_away_time)
	tween.parallel().tween_property(self, "position", position + Vector2(0, -vertical_displacement), burn_away_time)
	
	tween.tween_callback(self.queue_free)
	pass # Replace with function body.
