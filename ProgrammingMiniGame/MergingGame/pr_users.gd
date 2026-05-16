class_name pr_user_button extends ColorRect

@onready var label : Label = $Label
var pr_data : PullRequest

func _on_button_button_up() -> void:
	ProgrammingMiniGameSignal.pr_user_button_signal.emit(pr_data)

func _on_button_mouse_entered() -> void:
	ProgrammingMiniGameSignal.cursor_in.emit()

func _on_button_mouse_exited() -> void:
	ProgrammingMiniGameSignal.cursor_out.emit()
