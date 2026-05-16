extends Node2D

var minigames = [
	preload("res://DrivingMiniGame/Scenes/driving_mini_game.tscn"),
	preload("res://ButtonMiniGame/button_mash_game.tscn"),
	preload("res://ProgrammingMiniGame/BugSmashingSubMiniGame/mini_game_manager.tscn"),
	preload("res://divorce_paper_minigame/divorce_paper_minigame.tscn"),
	preload("res://memory_pick_minigame/memory_pick.tscn")
]
var current_level
@onready var MinigameContainer = $"../Minigames"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level(index):
	if current_level:
		current_level.queue_free()
	current_level = minigames[index].instantiate()
	MinigameContainer.add_child(current_level)
	
