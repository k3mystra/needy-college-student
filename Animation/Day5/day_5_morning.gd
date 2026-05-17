extends Node2D

@onready var animation = $AnimationPlayer
signal minigame_finished 

func _ready() -> void:
	animation.play("day_5_morning")
	await animation.animation_finished
	minigame_finished.emit()
	
