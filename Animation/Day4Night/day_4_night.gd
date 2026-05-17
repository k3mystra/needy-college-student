extends Node2D

@onready var animation = $AnimationPlayer
signal minigame_finished 

func _ready() -> void:
	animation.play("new_animation")
	await animation.animation_finished
	minigame_finished.emit()
	
