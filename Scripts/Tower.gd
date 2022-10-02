extends Area2D
class_name Tower

enum TargetingCategory {
	FIRST, STRONG, SPOT
}

@export var tower_name : String
@export var ui_image : Texture2D
@export var clan : Game.Clan
@export var element : Element

@export var projecticle : PackedScene 
@export var aoe : PackedScene 

@export var damage = 100
@export var attack_duration = 3
@export var attack_range = 400

@export var targeting_category = TargetingCategory.FIRST
@export var is_aoe = false
@export var aoe_range = 30
var spot = null
var drawing_range_circle = false

var activated = false
var tick_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var collision_shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.set_radius(float(attack_range))
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
	if not is_aoe and activated:
		if activated and tick_counter < attack_duration:
			attack()
			tick_counter+=1
		if tick_counter >= attack_duration:
			deactivate()
	elif is_aoe and activated:
		attack()
		deactivate()
			
func attack() -> void:
	var target = null
	match targeting_category:
		TargetingCategory.FIRST:
			target = target_first()
			pass
		TargetingCategory.STRONG:
			target = target_strong()
			pass
		TargetingCategory.SPOT:
			target = spot
			pass
	
	if target != null:
		print(target)
		if is_aoe:
			spawn_aoe(target)
			pass
		else:
			spawn_projectile(target)
		pass

func spawn_aoe(target: Vector2):
	var new_proj = aoe.instantiate()

	new_proj.damage  = damage
	new_proj.element = element
	new_proj.radius = aoe_range
	new_proj.lifetime = attack_duration
	
	add_child(new_proj)
	
	new_proj.global_position = target
	pass
	
func spawn_projectile(target: Vector2):
	var new_proj = projecticle.instantiate()
	
	new_proj.damage  = damage
	new_proj.element = element
	new_proj.target  = target
	
	add_child(new_proj)
	pass

func target_first():
	var enemy_areas_in_range = $TargetingRangeOverlapArea.get_overlapping_areas()
	
	print(enemy_areas_in_range)
	
	if enemy_areas_in_range.size() > 0:
		var furthest_enemy = enemy_areas_in_range[0].get_parent()
		for enemy_area in enemy_areas_in_range:
			var enemy = enemy_area.get_parent() as Enemy
			
			if enemy.progress_ratio > furthest_enemy.progress_ratio:
				furthest_enemy = enemy
	
		return furthest_enemy.global_position
	else:
		return null

func target_strong():
	var enemy_areas_in_range = $TargetingRangeOverlapArea.get_overlapping_areas()
	
	print(enemy_areas_in_range)
	
	if enemy_areas_in_range.size() > 0:
		var strongest_enemy = enemy_areas_in_range[0].get_parent()
		for enemy_area in enemy_areas_in_range:
			var enemy = enemy_area.get_parent() as Enemy
			
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
		draw_circle(Vector2.ZERO, attack_range, Color(Color.CHARTREUSE, 0.1))
		if spot != null:
			print('drawing at offset %s', spot - global_position)
			draw_circle(spot - global_position, aoe_range, Color(Color.BLUE, 0.2))
		
