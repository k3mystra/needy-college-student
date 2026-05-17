extends Node2D

signal minigame_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("play")

func _process(delta: float) -> void:
	if Global.total_time < 0:
		minigame_finished.emit()
