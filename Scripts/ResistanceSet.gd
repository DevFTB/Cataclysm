extends Resource
class_name ResistanceSet

@export var resistances : Dictionary
@export var default_value : float = 1

func _init(p_resistances: Dictionary = {}, p_default_value : float = 1.0):
	resistances = p_resistances
	default_value = p_default_value


func get_resistance(element: Element):
	if resistances.has(element):
		return resistances[element]
	else:
		return default_value

static func combine_resistances(rs_list: Array):
	var keys = []
	var combined = {}
	var combined_default = 1
	
	for rs in rs_list:
		keys.append_array(rs.resistances.keys())
		combined_default *= rs.default_value

	for k in keys:
		if not combined.has(k):
			combined[k] = 1

	for e in combined.keys():
		for rs in rs_list:
			combined[e] = combined[e] * rs.get_resistance(e)

	return ResistanceSet.new(combined, combined_default)

