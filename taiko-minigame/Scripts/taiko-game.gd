
extends Node2D

# --- RNG ----------------------------------------------------------------------
var rng = RandomNumberGenerator.new()

# --- TIMING -------------------------------------------------------------------
const BPM := 72.0
const BEAT_SEC := 60.0 / BPM
const SONG_DURATION := 10.0
const HIT_WINDOW := 0.18
const LOOK_AHEAD := 2.5   # seconds ahead to spawn notes

# --- MAPS ---------------------------------------------------------------------
# Each map is a different "song" / difficulty pattern.
# Format per entry: [beat_number, note_type]
# note_type: 0 = small (F key), 1 = big (J key)
# One map is picked randomly each time the game starts.

const MAP_CHECKED_OUT: Array = [
	[2,  0], [4,  0], [8,  1],
	[12, 0], [16, 1], [20, 0],
	[24, 0], [28, 1], [32, 0],
	[36, 0], [40, 1], [44, 0],
	[48, 0], [52, 1], [56, 0],
	[60, 0], [64, 1], [68, 0],
]

const MAP_THE_GRIND: Array = [
	[1,  0], [2,  0], [3,  1], [4,  0],
	[5,  0], [6,  0], [7,  0], [8,  1],
	[9,  0], [10, 0], [11, 0], [12, 0],
	[13, 1], [14, 0], [15, 0], [16, 1],
	[17, 0], [18, 0], [19, 0], [20, 0],
	[21, 0], [22, 1], [23, 0], [24, 0],
	[25, 0], [26, 0], [27, 0], [28, 1],
	[29, 0], [30, 0], [31, 1], [32, 0],
	[33, 0], [34, 0], [35, 0], [36, 0],
	[37, 1], [38, 0], [39, 0], [40, 1],
	[41, 0], [41.5, 0], [42, 0], [42.5, 0],
	[43, 1], [44, 0], [45, 0], [46, 0],
	[47, 0], [48, 1], [49, 0], [50, 0],
	[51, 0], [52, 0], [53, 1], [54, 0],
	[55, 0], [56, 0], [57, 0], [58, 1],
	[59, 0], [60, 0], [61, 0], [62, 0],
	[63, 1], [63.5, 0], [64, 1], [64.5, 0],
	[65, 0], [66, 0], [67, 0], [68, 1],
]

const MAP_PER_MY_LAST_EMAIL: Array = [
	[1, 0], [1.5, 0], [2, 1], [2.5, 0], [3, 0], [3.5, 0], [4, 1],
	[5, 0], [5.5, 0], [6, 0], [6.5, 1], [7, 0], [7.5, 0], [8, 1],
	[9, 0], [10, 1], [10.5, 0], [11, 0], [12, 1],
	[13, 0], [13.5, 0], [14, 0], [14.5, 1], [15, 0], [16, 1],
	[17, 0], [17.5, 0], [18, 1], [18.5, 0], [19, 0], [20, 1],
	[21, 0], [22, 0], [22.5, 0], [23, 1], [24, 0],
	[25, 0], [25.5, 0], [26, 1], [27, 0], [27.5, 0], [28, 1],
	[29, 0], [30, 0], [30.5, 1], [31, 0], [32, 1],
	[33, 0], [33.5, 0], [34, 0], [34.5, 1], [35, 0], [36, 1],
	[37, 0], [37.5, 0], [38, 1], [38.5, 0], [39, 0], [40, 1],
	[41, 0], [41.5, 1], [42, 0], [42.5, 0], [43, 1],
	[44, 0], [44.5, 0], [45, 1], [46, 0], [46.5, 1],
	[47, 0], [48, 0], [48.5, 1], [49, 0], [50, 1],
	[51, 0], [51.5, 0], [52, 1], [52.5, 0], [53, 0], [54, 1],
	[55, 0], [56, 1], [56.5, 0], [57, 0], [58, 1],
	[59, 0], [59.5, 0], [60, 1], [61, 0], [62, 1],
	[63, 0], [63.5, 1], [64, 0], [64.5, 0], [65, 1],
	[66, 0], [66.5, 0], [67, 1], [67.5, 0], [68, 1],
]

const MAP_BLINDSIDED: Array = [
	[1, 0], [3, 1], [5, 0], [5.5, 0],
	[8, 1], [9, 0], [9.5, 0], [10, 0],
	[12, 1], [14, 0], [14.5, 1],
	[16, 0], [17, 0], [17.5, 0], [18, 1],
	[20, 0], [21, 1], [21.5, 0], [22, 0],
	[24, 1], [26, 0], [27, 1],
	[28, 0], [28.5, 0], [29, 0], [30, 1],
	[32, 0], [33, 0], [33.5, 1], [34, 0],
	[36, 1], [37, 0], [38, 0], [38.5, 0],
	[40, 1], [41, 0], [41.5, 1], [42, 0],
	[44, 0], [45, 0], [45.5, 0], [46, 1],
	[48, 0], [49, 1], [50, 0], [50.5, 0],
	[52, 1], [53, 0], [54, 1],
	[56, 0], [57, 0], [57.5, 1], [58, 0],
	[60, 1], [61, 0], [62, 0], [62.5, 0],
	[64, 1], [65, 0], [65.5, 1], [66, 0],
	[68, 1],
]

# Array for the maps. Add more here.
const MAPS: Array = [
	["Checked Out", MAP_CHECKED_OUT],
	["The Grind", MAP_THE_GRIND],
	["Per My Last Email", MAP_PER_MY_LAST_EMAIL],
	["Blindsided", MAP_BLINDSIDED],
]

# --- BUZZWORDS ----------------------------------------------------------------
const BUZZWORDS: Array[String] = [
	"synergy", "bandwidth", "circle back", "deliverable",
	"leverage", "pivot", "ideate", "low-hanging fruit",
	"deep dive", "move the needle", "touch base", "align",
	"proactive", "value-add", "scalable", "agile",
]

# --- RUNTIME STATE ------------------------------------------------------------
var song_time := 0.0
var is_playing := false
var chart_index := 0
var active_notes: Array = []
var active_chart: Array = []    # whichever map was picked this run
var active_map_name: String = ""
var score := 0
var combo := 0
var misses := 0
var lunch_remaining := 0.1 * 60.0
var slack_timer := 0.0
var slack_visible := false
var feedback_timer := 0.0

# --- NODE REFERENCES ----------------------------------------------------------
@onready var background:  TextureRect   = $Background
@onready var monitor: ColorRect     = $Monitor
@onready var monitor_text: RichTextLabel = $MonitorText
@onready var boss: TextureRect   = $Boss
@onready var desk: TextureRect   = $Desk
@onready var stress_ball: TextureRect   = $StressBall
@onready var rhythm_lane: Control       = $RhythmLane
@onready var hit_zone: ColorRect     = $RhythmLane/HitZone
@onready var note_container: Node2D        = $NoteContainer
@onready var slack_panel: Panel         = $SlackMessage
@onready var slack_label: Label         = $SlackMessage/SlackLabel
@onready var lunch_clock: Label         = $LunchClock
@onready var feedback_label: Label         = $FeedbackLabel
@onready var combo_label: Label         = $ComboLabel

# --- COLOURS ------------------------------------------------------------------
const C_BG          := Color(0.10, 0.10, 0.10)
const C_MONITOR     := Color(0.08, 0.12, 0.18)
const C_SUIT        := Color(0.15, 0.15, 0.17)
const C_DESK        := Color(0.18, 0.13, 0.10)
const C_NOTE_SMALL  := Color(0.032, 0.457, 0.822, 1.0)
const C_NOTE_BIG    := Color(1.0, 0.177, 0.2, 1.0)
const C_HITZONE     := Color(0.22, 0.22, 0.25)
const C_LANE        := Color(0.14, 0.14, 0.16)
const C_TEXT        := Color(0.50, 0.50, 0.52)
const C_MISS        := Color(0.744, 0.835, 0.831, 1.0)
const C_HIT         := Color(0.294, 0.464, 0.28, 1.0)

# --- SETUP --------------------------------------------------------------------
func _ready() -> void:
	_build_scene()
	_show_intro()

func _build_scene() -> void:
	var vp: Vector2 = Vector2(1920, 1080)

	background.texture = load("res://taiko-minigame/Assets/taiko-office-fpv.png")
	background.size    = vp

	monitor.color    = C_MONITOR
	monitor.size     = Vector2(vp.x * 0.55, vp.y * 0.30)
	monitor.position = Vector2(vp.x * 0.22, vp.y * 0.04)

	monitor_text.size     = monitor.size - Vector2(16, 16)
	monitor_text.position = monitor.position + Vector2(8, 8)
	monitor_text.add_theme_color_override("default_color", C_TEXT * 0.8)

	boss.texture  = load("res://taiko-minigame/Assets/taiko-boss.png")
	boss.size     = Vector2(vp.x * 0.28, vp.y * 0.42)
	boss.position = Vector2(vp.x * 0.10, vp.y * 0.05)

	desk.texture  = load("res://taiko-minigame/Assets/taiko-office-fpv.png/")
	desk.size     = Vector2(vp.x, vp.y * 0.18)
	desk.position = Vector2(0, vp.y * 0.72)

	stress_ball.texture  = load("res://taiko-minigame/Assets/taiko-loose.png")
	stress_ball.size     = Vector2(40, 40)
	stress_ball.position = Vector2(-700, 400)

	rhythm_lane.size     = Vector2(vp.x * 0.90, 72)
	rhythm_lane.position = Vector2(vp.x * 0.05, vp.y * 0.62)

	hit_zone.color    = C_HITZONE
	hit_zone.size     = Vector2(80, 80)
	hit_zone.position = Vector2.ZERO

	slack_panel.size     = Vector2(300, 100)
	slack_panel.position = Vector2(vp.x - 380, 12)
	slack_panel.hide()

	lunch_clock.position = Vector2(vp.x - 400, vp.y * 0.03)
	lunch_clock.add_theme_color_override("font_color", C_TEXT)

	feedback_label.position = Vector2(vp.x * 0.5 - 150, vp.y * 0.57)
	feedback_label.add_theme_color_override("font_color", C_HIT)
	feedback_label.text = ""

	combo_label.position = Vector2(16, vp.y * 0.60)
	combo_label.add_theme_color_override("font_color", C_TEXT * 0.6)
	combo_label.text = ""

func _show_intro() -> void:
	feedback_label.text = "Press ENTER to not have lunch."
	feedback_label.add_theme_color_override("font_color", C_TEXT)

# --- INPUT --------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if not is_playing:
		if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
			_start_game()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_F: _attempt_hit(0)
			KEY_J: _attempt_hit(1)

func _attempt_hit(type: int) -> void:
	_animate_squeeze()
	var best_note = null
	var best_dist := 9999.0

	for note_data in active_notes:
		if note_data["hit"]:
			continue
		var dist: float = abs(float(note_data["beat_time"]) - song_time)
		if dist < HIT_WINDOW and dist < best_dist:
			best_dist = dist
			best_note = note_data

	if best_note != null:
		best_note["hit"] = true
		best_note["node"].queue_free()
		combo += 1
		score += 100 + (combo * 10)
		_show_feedback("HIT", C_HIT)
		combo_label.text = str(combo) if combo > 1 else ""
	else:
		_show_feedback("MISS", C_BG)
		combo = 0
		combo_label.text = ""

# --- GAME LOOP ----------------------------------------------------------------
func _start_game() -> void:
	# Pick a random map each run
	var pick: int   = rng.randi_range(0, MAPS.size() - 1)
	active_map_name = MAPS[pick][0]
	active_chart    = MAPS[pick][1]

	is_playing  = true
	song_time   = 0.0
	chart_index = 0
	score       = 0
	combo       = 0
	misses      = 0
	slack_timer = 5.0

	# Flashes the map name briefly
	feedback_label.add_theme_color_override("font_color", C_TEXT)
	feedback_label.text = active_map_name
	feedback_timer      = 2.5

func _process(delta: float) -> void:
	if not is_playing:
		return

	song_time       += delta
	lunch_remaining -= delta
	slack_timer     -= delta
	feedback_timer  -= delta

	_spawn_notes()
	_scroll_notes(delta)
	_cull_missed_notes()
	_update_lunch_clock()
	_handle_slack()

	if feedback_timer <= 0.0:
		feedback_label.text = ""

	if song_time >= SONG_DURATION:
		_end_game()

func _spawn_notes() -> void:
	while chart_index < active_chart.size():
		var entry     = active_chart[chart_index]
		var beat_num  = entry[0]
		var note_type = entry[1]
		var note_time: float = float(beat_num) * BEAT_SEC

		if note_time - song_time <= LOOK_AHEAD:
			_create_note(note_time, note_type)
			chart_index += 1
		else:
			break

func _create_note(beat_time: float, type: int) -> void:
	var lane_w: float = rhythm_lane.size.x
	var lane_h: float = rhythm_lane.size.y
	var word := BUZZWORDS[randi() % BUZZWORDS.size()]

	var note := Label.new()
	note.text = word
	note.add_theme_color_override("font_color", C_NOTE_BIG if type == 1 else C_NOTE_SMALL)
	note.add_theme_font_size_override("font_size", 30 if type == 1 else 25)

	var start_x: float = lane_w - 20.0
	var start_y: float = lane_h * 0.25 if type == 0 else lane_h * 0.55
	note.position = Vector2(start_x, start_y) + rhythm_lane.position

	note_container.add_child(note)

	active_notes.append({
		"node":      note,
		"beat_time": beat_time,
		"type":      type,
		"hit":       false,
	})

func _scroll_notes(delta: float) -> void:
	var lane_w: float = rhythm_lane.size.x
	var speed: float  = (lane_w - 64.0) / LOOK_AHEAD   # consistent for all notes
	for note_data in active_notes:
		if not note_data["hit"]:
			note_data["node"].position.x -= speed * delta

func _cull_missed_notes() -> void:
	var to_remove: Array = []
	for note_data in active_notes:
		if note_data["hit"]:
			continue
		var note_node: Label = note_data["node"]
		if note_node.position.x + note_node.size.x < 0:
			note_node.queue_free()
			to_remove.append(note_data)
			misses += 1
			combo   = 0
			combo_label.text = ""
			_show_feedback("MISS", C_MISS)

	for r in to_remove:
		active_notes.erase(r)

# --- UI UPDATES ---------------------------------------------------------------
func _update_lunch_clock() -> void:
	var mins: int = int(lunch_remaining / 60.0)
	var secs: int = int(lunch_remaining) % 60
	lunch_clock.text = "lunch: %02d:%02d" % [mins, secs]
	if lunch_remaining < 300:
		lunch_clock.add_theme_color_override("font_color", C_MISS)

func _animate_squeeze() -> void:
	stress_ball.texture = load("res://taiko-minigame/Assets/taiko-squeeze.png")
	await get_tree().create_timer(0.5).timeout
	stress_ball.texture = load("res://taiko-minigame/Assets/taiko-loose.png")

func _handle_slack() -> void:
	var setslacksize := LabelSettings.new()
	setslacksize.set_font_size(25)
	$SlackMessage/SlackLabel.label_settings = setslacksize
	if slack_timer <= 0.0 and not slack_visible:
		slack_label.text = "Boss: So.. per my last email..."
		slack_panel.show()
		slack_visible = true
		slack_timer   = 25.0
	elif slack_timer <= 0.0 and slack_visible:
		slack_panel.hide()
		slack_visible = false
		slack_timer   = 20.0

func _show_feedback(text: String, color: Color) -> void:
	feedback_label.text = text
	feedback_label.add_theme_color_override("font_color", color)
	feedback_timer = 0.4

# --- END STATE ----------------------------------------------------------------
func _end_game() -> void:
	is_playing = false
	for note_data in active_notes:
		note_data["node"].queue_free()
	#active_notes.clear()

	var total: int = active_chart.size()
	var accuracy := 0.0
	if total > 0:
		accuracy = float(total - misses) / float(total) * 100.0

	feedback_label.add_theme_color_override("font_color", C_TEXT)
	feedback_label.text = (
		"lunch is over.\n\nnothing went in %d%%\nyour head.\n\nnor your stomach."
		% [int(accuracy)]
	)
