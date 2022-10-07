extends AnimatedSprite2D

@export var sprite_sheet : Texture2D
@export var frame_size : Vector2 = Vector2(16, 16)
@export var animation_names : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite_sheet:
		regenerate_sprite_frames()
	
	pass # Replace with function body.

func regenerate_sprite_frames():
	var new_frames =  SpriteFrames.new()

	for i in range(animation_names.size()):
		var an = animation_names[i]
		new_frames.add_animation(an)
		for j in range(floor(frame_size.x / sprite_sheet.get_width())):
			var at = AtlasTexture.new()
			at.set_atlas(sprite_sheet)
			at.set_region(Rect2(j * frame_size.x, i * frame_size.y, frame_size.x, frame_size.y))
			new_frames.add_frame(an, at, j)
			
	frames = new_frames
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
