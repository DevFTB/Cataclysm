extends PathFollow2D
class_name Enemy

enum Element {
	WATER, AIR, EARTH, FIRE, ELECTRICITY, STEEL, DARK, LIGHT
}

enum Reaction {
	DIFFUSION, REPLACE, CIRCULATE, EVAPORATE, CORROSION, GLOOM, WEALTH, BARRICADE, POISON, OVERCLOCK, SMITE, REINFORCE, JUDGMENT
}

const reactions : Array[Array] = [[1,2,0,3,0,4,0,0],[2,1,0,2,2,0,5,0],[0,0,1,6,0,7,8,0],[3,2,6,1,0,0,0,0],[0,2,0,0,1,9,0,10],[4,0,7,0,9,11,0,0],[0,5,8,0,0,0,1,12],[0,0,0,0,10,0,12,1]]

@export var max_health = 50
@export var base_move_speed = 5

@export var enemy_name : String = "Enemy"
@export var resistances : Dictionary

@export var max_rand_offset : float = 25

@onready var health = max_health

@onready var game = get_node("/root/Game")

var rng = RandomNumberGenerator.new()
var applied_elements : Array[Element] = []

var is_dead = false

var is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	$SpriteBody.position += Vector2(0, rng.randf_range(-max_rand_offset, max_rand_offset))
	pass # Replace with function body.

var time = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game.game_paused:
		progress += base_move_speed * delta
		
	pass

func apply_resistances(damage: int, element: Element) -> int:
	return floor(damage * resistances[element])

func take_damage(damage: int, element: Element) -> void:
	applied_elements.append(element)
	var true_damage = apply_resistances(damage, element)
	
	modify_health(-1 * damage)
	pass

func modify_health(amount : int):
	health += amount
	
	var value = float(health) / float(max_health) * 100
	$HPBar.set_value(value)
	
	if health < 0:
		die()
	
func apply_elemental_reactions() -> Reaction:
	if applied_elements.size() > 2:
		return Reaction.DIFFUSION
	else:
		return reactions[applied_elements[0]][applied_elements[1]]
	pass
	
func die():
	is_dead = true
	print("enemy " + enemy_name + " has died")
	pass
