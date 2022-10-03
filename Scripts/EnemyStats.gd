extends Resource
class_name EnemyStats

@export var enemy_name : String = "Enemy"
@export var enemy_texture : Texture2D
@export var enemy_body_type : PackedScene

@export var max_health = 50
@export var base_move_speed = 5

@export var resistances : ResistanceSet

@export var currency_on_death : int = 1

@export var max_rand_offset : float = 0
