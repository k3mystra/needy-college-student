extends Node2D

@onready var git_window = $GitHubWindow

signal github_clicked

var window_open : bool = false

func _on_button_button_up() -> void:
	if window_open == false:
		print("1")
		github_clicked.emit()
		window_open = true 
		
		git_window.scale = Vector2.ZERO
		git_window.show() 
		
		var tween = create_tween()
		tween.tween_property(
			git_window, 
			"scale", 
			Vector2.ONE, 
			0.1
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		$GithubLogo/Area2D.remove_from_group("MonitorBugs")
		$GitHubWindow/Code/Area2D.add_to_group("MonitorBugs")
		$GitHubWindow/PullRequest/Area2D.add_to_group("MonitorBugs")

func disable_ide():
	$GitHubWindow/Code/Area2D.remove_from_group("MonitorBugs")
	$GitHubWindow/PullRequest/Area2D.remove_from_group("MonitorBugs")

#func disable_prs():
