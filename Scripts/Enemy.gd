extends PathFollow2D
class_name Enemy

class Damage:
	var damage: int
	var element: Element
	
	func _init(p_damage: int, p_element : Element):
		damage = p_damage
		element = p_element

@export var max_health = 50
@export var base_move_speed = 5

@export var enemy_name : String = "Enemy"
@export var resistances : Dictionary

@export var max_rand_offset : float = 0

@onready var health = max_health

@onready var game = get_node("/root/Game")

var rng = RandomNumberGenerator.new()
var applied_elements : Array[Element] = []
var is_dead = false
var is_paused

var resistance_cache : Dictionary = {}
var damage_cache : Array[Damage] = []

var move_speed_modifier = 1
var attack_modifier = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	$SpriteBody.position += Vector2(0, rng.randf_range(-max_rand_offset, max_rand_offset))
	pass # Replace with function body.

var time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game.game_paused:
		progress += base_move_speed * delta * move_speed_modifier
	pass

var tick_counter = 0
func tick():
	print('%s is ticking' % name)
	# 4. Apply Elements to Enemy => Generate Reactions <-- POST-TOWER PHASE
	react()
	apply_reaction_effects()
	
	# 5. Deal modified damaged  (dmg * resistances * reaction_multipliers)
	calculate_and_deal_damage()
	
	# 6. Check dead and do post-dead reactions <-- POST-DEAD PHASE
	if health <= 0:
		die()
	
	tick_counter+=1
	pass
	
func calculate_and_deal_damage():
	var total_damage = 0
	for dmg_instance in damage_cache:
		total_damage += apply_resistances(dmg_instance.damage, dmg_instance.element)
	modify_health(-1 * total_damage * attack_modifier)
	damage_cache.clear()
	resistance_cache.clear()
	attack_modifier = 1
	pass
	
func apply_resistances(damage: int, element: Element) -> int:
	var resistance = 1
	
	if resistances.has(element):
		resistance *= resistances[element]
	if resistance_cache.has(element):
		resistance *= resistance_cache[element]
	
	return floor(damage *  resistance)

func take_damage(damage: int, element: Element) -> void:
	if not applied_elements.has(element):
		applied_elements.append(element)
		$SpriteBody/ElementBar.show_elements(applied_elements)
	
	damage_cache.append(Damage.new(damage, element))
	pass

func modify_health(amount : int):
	health += amount
	
	var value = float(health) / float(max_health) * 100
	$SpriteBody/HPBar.set_value(value)
	
func react() -> void:
	if applied_elements.size() > 1:
		print('reacting %s' % applied_elements.map(func (v): return v.display_name))
		var reaction = game.get_reaction(applied_elements)
		print("generating reaction %s" % reaction.display_name)
		var new_rl = ReactionLifecycle.new()
		new_rl.reaction = reaction
		
		applied_elements.clear()
		$Reactions.add_child(new_rl)
		$SpriteBody/ElementBar.show_elements(applied_elements)
		
		
func apply_reaction_effects():
	var rls = $Reactions.get_children()
	for rl in rls:
		rl.tick()
		pass
	
	pass
	
func die():
	is_dead = true
	print("enemy " + enemy_name + " has died")
	
	apply_post_death_reactions()
	
	queue_free()
	pass
	
func apply_post_death_reactions():
	pass
	
	
func apply_resistance_modifier(modifier : Dictionary):
	for element in modifier.keys():
		if resistance_cache.has(element):
			resistance_cache[element] = resistance_cache[element] * modifier[element]
	pass
	
func apply_move_speed_modifier(modifier: float):
	move_speed_modifier *= modifier
	pass
	
func remove_move_speed_modifier(modifier: float):
	move_speed_modifier /= modifier
	pass
	
func apply_attack_modifier(modifier: float):
	attack_modifier *= modifier
	pass
	
func remove_attack_modifier(modifier: float):
	attack_modifier /= modifier
	pass
