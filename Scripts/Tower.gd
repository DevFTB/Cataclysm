extends Resource
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


@export var is_aoe = false
@export var aoe_range = 30
