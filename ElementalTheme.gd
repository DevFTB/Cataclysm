extends Resource

@export var element_names : Array[String]
@export var element_icons : Array[Texture2D]

@export var reactions : Array[Reaction]

var reaction_map = {}

func _init(p_names= [], p_icons = [], p_reactions = []):
	element_icons = p_icons
	element_names = p_names
	reactions = p_reactions
	
	for reaction in reactions.slice(2):
		var sum = 0
		for e in reaction.elements:
			sum += 2^e
		reaction_map[sum] = reaction

func get_icon(name: String):
	var index = element_names.find(name)
	if index != -1:
		return element_icons[index]
	else: 
		return null
		
func get_reaction(e1: int, e2: int) -> Reaction:
	var reaction =  reactions[reaction_map[e1][e2]]
	if reaction == null:
		if e1 == e2:
			return reactions[1]
		else:
			return reactions[0]
	else:
		return reaction
	
