class_name MemoryData
extends Resource

@export var sprite: Texture2D
@export var is_wanted: bool


func _init(p_sprite = null, p_isWanted = false) -> void:
	sprite = p_sprite
	is_wanted = p_isWanted
