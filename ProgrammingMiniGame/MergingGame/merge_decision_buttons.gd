class_name merge_decision_buttons extends Node2D

var active : bool = false

var mouse_in : bool

func _ready() -> void:
	hide()
	ProgrammingMiniGameSignal.pr_user_button_signal.connect(show_self)
	
func show_self(pr:PullRequest):
	if active == false:
		show()
		active = true
	else:
		hide()
		active = false

func _on_merge_button_up() -> void:
	ProgrammingMiniGameSignal.merge_button_pressed.emit()
	hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if mouse_in == false:
				active = false
				hide()

func _on_control_mouse_entered() -> void:
	mouse_in = true

func _on_control_mouse_exited() -> void:
	mouse_in = false
