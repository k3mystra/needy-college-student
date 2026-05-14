class_name merge_decision_buttons extends Node2D

var active : bool = false

func _ready() -> void:
	hide()
	ProgrammingMiniGameSignal.pull_request_button_pressed.connect(show_self)
	
func show_self():
	if active == false:
		show()
		active = true
	else:
		hide()
		active = false

func _on_merge_button_up() -> void:
	ProgrammingMiniGameSignal.merge_button_pressed.emit()
	hide()
