extends Node2D

var minigames = [
	preload("res://DrivingMiniGame/Scenes/driving_mini_game.tscn"),
	preload("res://ButtonMiniGame/button_mash_game.tscn"),
	preload("res://ProgrammingMiniGame/BugSmashingSubMiniGame/mini_game_manager.tscn"),
	preload("res://divorce_paper_minigame/divorce_paper_minigame.tscn"),
	preload("res://memory_pick_minigame/memory_pick.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
