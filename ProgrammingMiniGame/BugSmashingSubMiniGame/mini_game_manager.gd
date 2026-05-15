class_name progamming_mini_game_manager extends Node2D

var smashed_bug_counter : int = 0
var merge_complete : bool = false

func _ready() -> void:
	Input.mouse_mode == Input.MOUSE_MODE_HIDDEN
	ProgrammingMiniGameSignal.bug_smashed.connect(increment_smashed_bug)
	
func increment_smashed_bug():
	smashed_bug_counter += 1
	if smashed_bug_counter == 4:
		ProgrammingMiniGameSignal.end_bug_smashing.emit()
		merge_complete = true
				
	if $Monitor/AllBugs.get_child_count() == 1 and merge_complete == true:
		ProgrammingMiniGameSignal.all_bug_smashed.emit()
		smashed_bug_counter = 0
		merge_complete = false
	
	
