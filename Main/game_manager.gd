extends Node2D
# Driving game -> Programming Mini game -> Taiko Game -> 
# Beating It Game -> Divorce Paper Game -> Memory Game

var minigames = [
	preload("res://DrivingMiniGame/Scenes/driving_mini_game.tscn"),
	preload("res://ProgrammingMiniGame/BugSmashingSubMiniGame/mini_game_manager.tscn"),
	preload("res://ButtonMiniGame/button_mash_game.tscn"),
	preload("res://divorce_paper_minigame/divorce_paper_minigame.tscn"),
	preload("res://memory_pick_minigame/memory_pick.tscn")
]

var current_level
var levelProgression = 0
var changeLevel:bool = false
@onready var MinigameContainer = $"../Minigames"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(levelProgression)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_minigame_finished():
	levelProgression += 1
	
	if levelProgression < minigames.size():
		load_level(levelProgression)
	else:
		print("All minigames finished")

func load_level(index):
	if current_level:
		current_level.queue_free()
	current_level = minigames[index].instantiate()
	current_level.minigame_finished.connect(_on_minigame_finished)
	MinigameContainer.add_child(current_level)
	
