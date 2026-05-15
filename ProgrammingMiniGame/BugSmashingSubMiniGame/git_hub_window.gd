class_name git_hub_window extends Node2D

@onready var pull_request_window = $PullRequestWindow

var pr_window_on : bool = false

func _ready() -> void:
	pass

func _on_pull_request_button_button_up() -> void:
	if ide_on == true:
		$IDE.hide()
		ide_on = false
	if pr_window_on == false:
		ProgrammingMiniGameSignal.pull_request_button_pressed.emit()
		$PullRequestWindow.show()
		$PullRequestWindow/user.hide()
		$PullRequestWindow/DescriptionRect.hide()
		$PullRequestWindow/description.hide()
		$PullRequestWindow/TitleRect.hide()
		$PullRequestWindow/title.hide()
		pr_window_on = true
	else:
		ProgrammingMiniGameSignal.pull_request_button_pressed.emit()
		$PullRequestWindow.hide()
		pr_window_on = false
	
var ide_on : bool = false

func _on_code_button_button_up() -> void:
	if pr_window_on == true:
		ProgrammingMiniGameSignal.pull_request_button_pressed.emit()
		$PullRequestWindow.hide()
		pr_window_on = false
	if ide_on == false:
		$IDE.show()
		ide_on = true
	else:
		$IDE.hide()
		ide_on = false

	
		
