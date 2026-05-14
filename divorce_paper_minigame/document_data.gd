class_name DocumentData
extends Resource


@export var sprite: Texture2D
@export var sign_position: Vector2


func _init(p_sprite = null, p_sign_position = Vector2(0,0)) -> void:
	sprite = p_sprite
	sign_position = p_sign_position
