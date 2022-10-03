extends Area2D
class_name TowerLifecycle
var tower : Tower

var spot = null
var drawing_range_circle = false

var activated = false
var tick_counter = 0
var targeting_category = Tower.TargetingCategory.FIRST
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2d.texture = tower.ui_image
	
	var collision_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.set_radius(float(tower.attack_range))
	collision_shape.shape = circle
	
	$TargetingRangeOverlapArea.add_child(collision_shape)
	pass # Replace with function body.

func set_spot(new_spot):
	spot = new_spot
	print('set spot %s' % spot)
	queue_redraw()
	
func activate() -> void:
	tick_counter = 0
	activated = true
	pass
	
func deactivate() -> void:
	activated = false
	
func tick() -> void:
	if not tower.is_aoe and activated:
		if activated and tick_counter < tower.attack_duration:
			attack()
			tick_counter+=1
		if tick_counter >= tower.attack_duration:
			deactivate()
	elif tower.is_aoe and activated:
		attack()
		deactivate()
			
func attack() -> void:
	var target = null
	match targeting_category:
		Tower.TargetingCategory.FIRST:
			target = target_first()
			pass
		Tower.TargetingCategory.STRONG:
			target = target_strong()
			pass
		Tower.TargetingCategory.SPOT:
			target = spot
			pass
	
	if target != null:
		print(target)
		if tower.is_aoe:
			spawn_aoe(target)
			pass
		else:
			spawn_projectile(target)
		pass

func spawn_aoe(target: Vector2):
	var new_proj = tower.aoe.instantiate()

	new_proj.damage  = tower.damage
	new_proj.element = tower.element
	new_proj.radius = tower.aoe_range
	new_proj.lifetime = tower.attack_duration
	new_proj.colour_override = tower.element.colour
	
	add_child(new_proj)
	
	new_proj.global_position = target
	pass
	
func spawn_projectile(target: Vector2):
	var new_proj = tower.projecticle.instantiate()
	
	new_proj.damage  = tower.damage
	new_proj.element = tower.element
	new_proj.target  = target
	
	add_child(new_proj)
	pass

func target_first():
	var enemy_areas_in_range = $TargetingRangeOverlapArea.get_overlapping_areas()
	
	print(enemy_areas_in_range)
	
	if enemy_areas_in_range.size() > 0:
		var furthest_enemy = enemy_areas_in_range[0].get_enemy()
		for enemy_area in enemy_areas_in_range:
			var enemy = enemy_area.get_enemy() as Enemy
			
			if enemy.progress_ratio > furthest_enemy.progress_ratio:
				furthest_enemy = enemy
	
		return furthest_enemy.global_position
	else:
		return null

func target_strong():
	var enemy_areas_in_range = $TargetingRangeOverlapArea.get_overlapping_areas()
	
	print(enemy_areas_in_range)
	
	if enemy_areas_in_range.size() > 0:
		var strongest_enemy = enemy_areas_in_range[0].get_enemy()
		for enemy_area in enemy_areas_in_range:
			var enemy = enemy_area.get_enemy() as Enemy
			
			if enemy.max_health > strongest_enemy.max_health:
				strongest_enemy = enemy
	
		print("targeting %s" % strongest_enemy.name)
		return strongest_enemy.global_position
	else:
		return null
	
	
func target_spot() -> void:
	if spot == null:
		target_first()
	else:
		return spot


func set_highlight(value) -> void:
	$Sprite2d.set_highlight(value)
	drawing_range_circle = value
	queue_redraw()
		
func _draw():
	if drawing_range_circle:
		draw_circle(Vector2.ZERO, tower.attack_range, Color(Color.CHARTREUSE, 0.1))
		if spot != null:
			print('drawing at offset %s', spot - global_position)
			draw_circle(spot - global_position, tower.aoe_range, Color(Color.BLUE, 0.2))
		
