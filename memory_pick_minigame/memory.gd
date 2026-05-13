extends CharacterBody2D

var is_wanted: bool


func set_memory_data(memory_data: MemoryData) -> void:
	$Sprite.texture = memory_data.sprite
	is_wanted = memory_data.is_wanted


func get_is_memory_wanted() -> bool:
	return is_wanted
