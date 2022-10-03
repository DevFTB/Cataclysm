extends Area2D
class_name TowerLifecycle
var tower : Tower

var spot = null
var drawing_range_circle = false

var activated = false
var tick_counter = 0
var targeting_category = Tower.TargetingCategory.FIRST

var range_upgrade = 0
var duration_upgrade = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2d.texture = tower.ui_image
	$AudioStreamPlayer2d.stream = tower.attack_sound
	regenerate_collision_shape(tower.attack_range)
	
	pass # Replace with function body.
func regenerate_collision_shape(range):
	var collision_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.set_radius(float(range))
	collision_shape.shape = circle
	
	$TargetingRangeOverlapArea.add_child(collision_shape)

func apply_upgrade(duration_up, range_up):
	var game = get_node("/root/Game")
	var cost  =tower.get_upgrade_cost(duration_upgrade + range_upgrade)
	
	if game.can_buyi(cost):
		if duration_upgrade + range_upgrade + 1 <= tower.upgrade_cost_multipliers.size():
			duration_upgrade += duration_up
			range_upgrade += range_up
			if range_up > 0:
				regenerate_collision_shape(get_range())
				queue_redraw()
			game.spend_currency(cost)

func set_spot(new_spot):
	spot = new_spot
	print('set spot %s' % spot)
	queue_redraw()
	
func activate() -> void:
	tick_counter = 0
	activated = true
	
	$AudioStreamPlayer2d.play()
	pass
	
func get_range():
	return tower.attack_range * (1 + 0.3 * range_upgrade)
	
func get_duration():
	return tower.attack_duration + floori(float(duration_upgrade) / 1)
	
func deactivate() -> void:
	activated = false
	
func tick() -> void:
	if not tower.is_aoe and activated:
		if tick_counter > 0:
				$Node2d/Label.modulate = Color.WHITE
		if activated and tick_counter < tower.attack_duration:
			if tick_counter == 0:
				$Node2d/Label.modulate = Color.YELLOW
			attack()
			tick_counter+=1
		if tick_counter >= get_duration():
			deactivate()
	elif tower.is_aoe and activated:
		attack()
		deactivate()
			
func attack() -> void:
	match targeting_category:
		Tower.TargetingCategory.FIRST:
			attack_entity(target_first())
			pass
		Tower.TargetingCategory.STRONG:
			attack_entity(target_strong())
			pass
		Tower.TargetingCategory.SPOT:
			attack_spot(target_spot())
			pass

func attack_entity(entity):
	if entity != null:
		if not tower.is_aoe:
			spawn_projectile(entity)
		else:
			spawn_aoe(entity.global_position)
		pass
	
func attack_spot(target):
	if target != null:
		if tower.is_aoe:
			spawn_aoe(target)

func spawn_aoe(target: Vector2):
	var new_proj = tower.aoe.instantiate()

	new_proj.damage  = tower.damage
	new_proj.element = tower.element
	new_proj.radius = tower.aoe_range
	new_proj.lifetime = get_duration()
	new_proj.colour_override = tower.element.colour
	
	add_child(new_proj)
	
	new_proj.global_position = target
	pass
	
func spawn_projectile(entity: Node2D):
	var new_proj = tower.projecticle.instantiate()
	
	new_proj.damage  = tower.damage
	new_proj.element = tower.element
	new_proj.target_entity  = entity
	
	
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
	
		return furthest_enemy
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
		return strongest_enemy
	else:
		return null
	
	
func target_spot() -> void:
	if spot == null:
		return target_first().global_position
	else:
		return spot


func set_highlight(value) -> void:
	$Sprite2d.set_highlight(value)
	drawing_range_circle = value
	queue_redraw()
		
func _draw():
	if drawing_range_circle:
		draw_circle(Vector2.ZERO, get_range(), Color(Color.CHARTREUSE, 0.1))
		if spot != null:
			print('drawing at offset %s', spot - global_position)
			draw_circle(spot - global_position, tower.aoe_range, Color(Color.BLUE, 0.2))
		

func refund():
	get_node("/root/Game").unregister_tower(self)
	get_node("/root/Game").add_to_currency(tower.get_refund_price())
	get_node("/root/Game")
	queue_free()

func set_tick(tick):
	$Node2d/Label.text = str(tick + 1)
