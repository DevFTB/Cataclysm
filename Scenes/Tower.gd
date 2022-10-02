extends Area2D
class_name Tower

enum TargetingCategory {
	FIRST, STRONG, SPOT
}

@export var tower_name : String
@export var ui_image : Texture2D
@export var clan : Game.Clan
@export var element : Game.Element

@export var projecticle : PackedScene 
@export var damage = 100
@export var attack_duration = 3
@export var attack_range = 400

@export var targeting_category = TargetingCategory.FIRST
@export var is_aoe = false
@export var aoe_range = 30


var spot : Vector2 = Vector2(0, 0)

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func activate() -> void:
	tick_counter = 0
	activated = true
	pass
	
func deactivate() -> void:
	activated = false
	
func tick() -> void:
	if tick_counter >= attack_duration and activated:
		deactivate()
		
	if activated and tick_counter < attack_duration:
		attack()
		tick_counter+=1
		
func attack() -> void:
	print("%s attempting attack" % name)
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
	
	print("Target is %s" % target)
	if target != null:
		print(target)
		if is_aoe:
			pass
		else:
			spawn_projectile(target)
		pass

	
func spawn_projectile(target: Vector2):
	print('spawning projectile')
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

func target_strong() -> void:
	var enemy_areas_in_range = $TargetingRangeOverlapArea.get_overlapping_areas()
	
	print(enemy_areas_in_range)
	
	if enemy_areas_in_range.size() > 0:
		var strongest_enemy = enemy_areas_in_range[0].get_parent()
		for enemy_area in enemy_areas_in_range:
			var enemy = enemy_area.get_parent() as Enemy
			
			if enemy.max_health > strongest_enemy.max_health:
				strongest_enemy = enemy
	
		return strongest_enemy.global_position
	else:
		return null
	return null
	
func target_spot() -> void:
	if spot == null:
		target_first()
	else:
		return null


func set_highlight(value) -> void:
	$Sprite2d.set_highlight(value)
	drawing_range_circle = value
	queue_redraw()
		
func _draw():
	if drawing_range_circle:
		draw_circle(Vector2.ZERO, attack_range, Color(Color.CHARTREUSE, 0.1))
		
