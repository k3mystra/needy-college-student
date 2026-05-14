class_name progamming_mini_game_manager extends Node2D

var smashed_bug_counter : int = 0

func _ready() -> void:
	Input.mouse_mode == Input.MOUSE_MODE_HIDDEN
	ProgrammingMiniGameSignal.bug_smashed.connect(increment_smashed_bug)

func increment_smashed_bug():
	smashed_bug_counter += 1
	if smashed_bug_counter == 4:
		ProgrammingMiniGameSignal.end_bug_smashing.emit()
	
