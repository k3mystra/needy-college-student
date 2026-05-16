extends ColorRect


func _on_pull_request_button_mouse_entered() -> void:
	ProgrammingMiniGameSignal.cursor_in.emit()

func _on_pull_request_button_mouse_exited() -> void:
	ProgrammingMiniGameSignal.cursor_out.emit()
