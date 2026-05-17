extends Node2D

@onready var animation = $AnimationPlayer
 
func _ready() -> void:
	animation.play("new_animation")
