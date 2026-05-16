extends Node2D

@onready var git_window = $GitHubWindow
@onready var pr_window : pull_request_window = $GitHubWindow/PullRequestWindow

@export var pr_user : PackedScene

signal github_clicked

var window_open : bool = false

var pull_request_list : Array[PullRequest] = []

var current_selected_pr : PullRequest

# PRELOAD SOUNDS HERE
var githubopen = preload("res://ProgrammingMiniGame/sounds/open.ogg")
var merge = preload("res://ProgrammingMiniGame/sounds/merge.ogg")
var merge_good = preload("res://ProgrammingMiniGame/sounds/mergegood.ogg")

func _ready():
	ProgrammingMiniGameSignal.all_bug_smashed.connect(finish_debug)
	ProgrammingMiniGameSignal.pr_user_button_signal.connect(update_pr_tab)
	ProgrammingMiniGameSignal.merge_button_pressed.connect(execute_merge)	
	$GitHubWindow/PullRequestWindow/TitleRect.hide()
	$GitHubWindow/PullRequestWindow/DescriptionRect.hide()
	for i in randi_range(1,4):
		pull_request_list.append(generate_pr())
	generate_pr_tab()

func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func execute_merge():
	var i = randf()
	if i > current_selected_pr.good_merge_chance:
		play_sound(merge, 1, 1)
		#trigger bus smashing game
		$GitHubWindow/PullRequest.hide()
		$GitHubWindow/Code.hide()
		$GitHubWindow/IDE.hide()
		$GitHubWindow/PullRequestWindow.hide()
		ProgrammingMiniGameSignal.start_bug_smashing.emit()
		$GitHubWindow/Debug.show()
	else:
		play_sound(merge_good, 1, 1)
		finish_debug()
		$GitHubWindow/PullRequestWindow.hide()
		
func generate_pr() -> PullRequest:
	if pull_request_list.size() >= PullRequest.PR_POOL.size():
		print("Warning: All unique pull requests are already in use!")
		return PullRequest.new() 
	var new_pr = PullRequest.new()
	while is_pr_already_in_list(new_pr):
		new_pr = PullRequest.new()
	return new_pr

func is_pr_already_in_list(target_pr: PullRequest) -> bool:
	for existing_pr in pull_request_list:
		if existing_pr.title == target_pr.title:
			return true
	return false
	
func generate_pr_tab():
	var counter = 1
	for i in pull_request_list:
		print("fahhhh")
		var new_pr = pr_user.instantiate() as pr_user_button
		$GitHubWindow/PullRequestWindow/All_prs.add_child(new_pr)
		new_pr.pr_data = i
		new_pr.label.text = i.user
		var slot : Marker2D = $GitHubWindow/PullRequestWindow/AllSlots.find_child(str(counter), false, true)
		new_pr.global_position = slot.global_position
		counter += 1

func update_pr_tab(pr : PullRequest):
	$GitHubWindow/PullRequestWindow/user.show()
	$GitHubWindow/PullRequestWindow/TitleRect.show()
	$GitHubWindow/PullRequestWindow/title.show()
	$GitHubWindow/PullRequestWindow/DescriptionRect.show()
	$GitHubWindow/PullRequestWindow/description.show()
	$GitHubWindow/PullRequestWindow/title.text = pr.title
	$GitHubWindow/PullRequestWindow/user.text = pr.user
	$GitHubWindow/PullRequestWindow/description.text = pr.description
	current_selected_pr = pr
	
func _on_button_button_up() -> void:
	if window_open == false:
		print("1")
		github_clicked.emit()
		window_open = true 
		
		git_window.scale = Vector2.ZERO
		git_window.show() 
		play_sound(githubopen, 1, 1)
		var tween = create_tween()
		tween.tween_property(
			git_window, 
			"scale", 
			Vector2.ONE, 
			0.1
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		$GithubLogo.hide()

func finish_debug():
	$GitHubWindow/Debug.hide()
	$GitHubWindow/Code.show()
	$GitHubWindow/PullRequest.show()
	var selected_child
	for i in $GitHubWindow/PullRequestWindow/All_prs.get_children():
		if i.pr_data.title	 == current_selected_pr.title:
			selected_child = i
	if selected_child != null:
		selected_child.queue_free()
	else:
		print("selected_child is null")
		return
	var found = false
	var remove_counter = 0
	for u in pull_request_list:
		if u.title == current_selected_pr.title:
			found = true
			break
		remove_counter += 1
	if found:
		pull_request_list.remove_at(remove_counter)
	
	var slot_counter = 1
	for x in pull_request_list:
		for y in $GitHubWindow/PullRequestWindow/All_prs.get_children():
			var z = y as pr_user_button
			if z.pr_data == x:
				z.global_position = $GitHubWindow/PullRequestWindow/AllSlots.find_child(str(slot_counter)).global_position
				slot_counter += 1
#func disable_prs():
