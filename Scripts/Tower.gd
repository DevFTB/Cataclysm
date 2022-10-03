extends Resource
class_name Tower

enum TargetingCategory {
	FIRST, STRONG, SPOT
}

@export var tower_name : String
@export var ui_image : Texture2D
@export var clan : Game.Clan
@export var element : Element

@export var currency_cost : int = 1
@export var attack_sound : AudioStreamWAV

@export var projecticle : PackedScene 
@export var aoe : PackedScene 

@export var damage = 100
@export var attack_duration = 3
@export var attack_range = 400

@export var is_aoe = false
@export var aoe_range = 30

const upgrade_cost_multipliers = [0.75, 1.25, 2.0, 5.0, 10.0, 100.0]

func get_upgrade_cost(upgrade_index: int):
	if upgrade_index >= upgrade_cost_multipliers.size():
		return null
	else:
		return floori(upgrade_cost_multipliers[upgrade_index] * currency_cost)

func get_refund_price() -> int:
	return roundi(float(currency_cost) / 2)
