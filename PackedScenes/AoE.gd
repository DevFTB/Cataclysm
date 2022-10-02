extends Node2D

var damage = 0
var radius = 0
var element : Element
var lifetime = 1
var count = 0

var enemies_inside = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Radius: %s" % radius)
	var circle = CircleShape2D.new()
	circle.set_radius(float(radius))
	$DamageArea/CollisionShape2d.shape = circle
	

	pass # Replace with function body.
	
func tick():
	print(enemies_inside)
	for enemy in $DamageArea.get_overlapping_areas().map(func (v): return v.get_parent()):
		
		enemy.take_damage(damage, element)
		print('damaging %s' % enemy.name)
	pass
	
	if lifetime <= count:
		queue_free()

	count += 1
func _draw():
	draw_circle(Vector2.ZERO, radius, Color(Color.RED, 0.3))
	pass
