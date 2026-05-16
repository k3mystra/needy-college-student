class_name monitor extends Node2D

@export var bug : PackedScene

@onready var monitor_bottom_left = $MonitorPNG/ScreenBottomLeft
@onready var monitor_bottom_right = $MonitorPNG/ScreenBottomRight
@onready var monitor_upper_right =$MonitorPNG/ScreenUpperRight
@onready var AllBugs = $AllBugs
@onready var pc : PC = $PC
@onready var github = $Github

var default_spawn_cd : int = 1

var monitor_x_range : Vector2 = Vector2(-1,-1)
var monitor_y_range : Vector2 = Vector2(-1,-1)

#PRELOAD SOUNDS HERE


func _ready() -> void:
	monitor_x_range.x = monitor_bottom_left.global_position.x
	monitor_x_range.y = monitor_bottom_right.global_position.x
	
	monitor_y_range.x = monitor_bottom_right.global_position.y
	monitor_y_range.y = monitor_upper_right.global_position.y
	
	pc.turn_on.connect(show_git)
	#$BugSpawnCD.start()
	pc.show()
	github.hide()
	github.git_window.hide()
	pc.blackscreen.show()
	ProgrammingMiniGameSignal.start_bug_smashing.connect(func(): $BugSpawnCD.start())
	ProgrammingMiniGameSignal.end_bug_smashing.connect(stop_bug_game)		

func stop_bug_game():
	$BugSpawnCD.stop()
	
func choose_rand_position() -> Vector2:
	var random_x = randf_range(monitor_x_range.x, monitor_x_range.y)
	var random_y = randf_range(monitor_y_range.x, monitor_y_range.y)
	return Vector2(random_x,random_y)		
	
func _process(delta: float) -> void:
	pass

func show_git():
	github.show()
	
func _on_bug_spawn_cd_timeout() -> void:
	var new_bug : code_bug = bug.instantiate()
	AllBugs.add_child(new_bug)
	new_bug.position = choose_rand_position()
	new_bug.rotation = randi_range(0,360)
	$BugSpawnCD.wait_time = default_spawn_cd * pow(0.99, AllBugs.get_child_count())


func _on_area_2d_mouse_entered() -> void:
	pass # Replace with function body.
	

func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
