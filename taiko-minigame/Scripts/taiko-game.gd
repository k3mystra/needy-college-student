
extends Node2D

# ─── TIMING ───────────────────────────────────────────────────────────────────
const BPM := 72.0                          # slow, oppressive tempo
const BEAT_SEC := 60.0 / BPM
const SONG_DURATION := 90.0               # seconds of suffering
const HIT_WINDOW := 0.18                  # seconds either side of perfect

# ─── RHYTHM CHART ─────────────────────────────────────────────────────────────
# Each entry: [beat_number, note_type]
# note_type: 0 = small squeeze (f key), 1 = big squeeze (j key)
const CHART: Array = [
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
	[41, 0], [41.5, 0], [42, 0], [42.5, 0],  # boss rambles faster
	[43, 1], [44, 0], [45, 0], [46, 0],
	[47, 0], [48, 1], [49, 0], [50, 0],
	[51, 0], [52, 0], [53, 1], [54, 0],
	[55, 0], [56, 0], [57, 0], [58, 1],
	[59, 0], [60, 0], [61, 0], [62, 0],
	[63, 1], [63.5, 0], [64, 1], [64.5, 0],
	[65, 0], [66, 0], [67, 0], [68, 1],
]

# Boss buzzwords that drift across the rhythm lane as notes
const BUZZWORDS: Array[String] = [
	"synergy", "bandwidth", "circle back", "deliverable",
	"leverage", "pivot", "ideate", "low-hanging fruit",
	"deep dive", "move the needle", "touch base", "align",
	"proactive", "value-add", "scalable", "agile",
]

# ─── RUNTIME STATE ─────────────────────────────────────────────────────────────
var song_time := 0.0
var is_playing := false
var chart_index := 0
var active_notes: Array = []        # [{node, beat_time, type, hit}]
var score := 0
var combo := 0
var misses := 0
var lunch_remaining := 0.1 * 60.0  # 30 minutes of lunch, ticking down
var slack_timer := 0.0
var slack_visible := false
var feedback_timer := 0.0
var squeeze_scale := 1.0            # stress ball animation

# Node references (assigned in _ready)
@onready var background: TextureRect  = $Background
@onready var monitor: ColorRect  = $Monitor
@onready var monitor_text: RichTextLabel = $MonitorText
@onready var boss: TextureRect = $Boss
@onready var boss_hands: ColorRect = $BossHands
@onready var desk:  TextureRect = $Desk
@onready var stress_ball: TextureRect = $StressBall
@onready var rhythm_lane: Control = $RhythmLane
@onready var hit_zone: ColorRect = $RhythmLane/HitZone
@onready var note_container:  Node2D  = $NoteContainer
@onready var slack_panel: Panel = $SlackMessage
@onready var slack_label: Label = $SlackMessage/SlackLabel
@onready var lunch_clock: Label = $LunchClock
@onready var feedback_label: Label  = $FeedbackLabel
@onready var combo_label: Label = $ComboLabel

# ─── COLOURS ──────────────────────────────────────────────────────────────────
const C_BG          := Color(0.10, 0.10, 0.10)
const C_MONITOR     := Color(0.08, 0.12, 0.18)
const C_SUIT        := Color(0.15, 0.15, 0.17)
const C_DESK        := Color(0.18, 0.13, 0.10)
const C_BALL        := Color(0.55, 0.20, 0.20)
const C_BALL_SQUEEZ := Color(0.70, 0.25, 0.22)
const C_NOTE_SMALL  := Color(0.45, 0.45, 0.50)
const C_NOTE_BIG    := Color(0.60, 0.55, 0.45)
const C_HITZONE     := Color(0.22, 0.22, 0.25)
const C_LANE        := Color(0.14, 0.14, 0.16)
const C_TEXT        := Color(0.50, 0.50, 0.52)
const C_MISS        := Color(0.40, 0.25, 0.25)
const C_HIT         := Color(0.40, 0.42, 0.40)

# ─── SETUP ────────────────────────────────────────────────────────────────────
func _ready() -> void:
	_build_scene()
	_show_intro()

func _build_scene() -> void:
	var vp: Vector2 = Vector2(1920,1080)

	## Display size
	#DisplayServer.window_set_size(Vector2(1920,1080))

	# Backgroundff
	background.texture = load("res://taiko-minigame/Assets/taiko-office-fpv.png")
	background.size  = vp

	# Monitor — top half, slightly off-centre
	monitor.color    = C_MONITOR
	monitor.size     = Vector2(vp.x * 0.55, vp.y * 0.30)
	monitor.position = Vector2(vp.x * 0.22, vp.y * 0.04)

	# Monitor text
	monitor_text.size     = monitor.size - Vector2(16, 16)
	monitor_text.position = monitor.position + Vector2(8, 8)
	monitor_text.add_theme_color_override("default_color", C_TEXT * 0.8)

	# Boss torso — no face, just a suit filling centre
	boss.texture  = load("res://taiko-minigame/Assets/taiko-boss.png")
	boss.size     = Vector2(vp.x * 0.28, vp.y * 0.42)
	boss.position = Vector2(vp.x * 0.10, vp.y * 0.05)

	# Boss hands — mug suggestion at bottom of torso
	boss_hands.color    = C_SUIT * 1.1
	boss_hands.size     = Vector2(vp.x * 0.12, vp.y * 0.06)
	boss_hands.position = Vector2(vp.x * 0.44, vp.y * 0.48)

	# Desk
	desk.texture  = load("res://taiko-minigame/Assets/taiko-office-fpv.png/")
	desk.size     = Vector2(vp.x, vp.y * 0.18)
	desk.position = Vector2(0, vp.y * 0.72)

	# Stress ball
	stress_ball.texture  = load("res://taiko-minigame/Assets/taiko-loose.png")
	stress_ball.size     = Vector2(40, 40)
	stress_ball.position = Vector2(-700,400)

	# Rhythm lane
	rhythm_lane.size     = Vector2(vp.x * 0.90, 72)
	rhythm_lane.position = Vector2(vp.x * 0.05, vp.y * 0.62)

	# Hit zone inside lane
	hit_zone.color    = C_HITZONE
	hit_zone.size     = Vector2(80, 80)
	hit_zone.position = Vector2.ZERO

	# Slack panel — hidden
	slack_panel.size     = Vector2(300, 100)
	slack_panel.position = Vector2(vp.x - 400, 12)
	slack_panel.hide()

	# Labels
	lunch_clock.position = Vector2(vp.x - 400, vp.y * 0.03)
	lunch_clock.add_theme_color_override("font_color", C_TEXT)

	feedback_label.position          = Vector2(vp.x * 0.5 - 80, vp.y * 0.57)
	feedback_label.add_theme_color_override("font_color", C_HIT)
	feedback_label.text              = ""

	combo_label.position = Vector2(16, vp.y * 0.60)
	combo_label.add_theme_color_override("font_color", C_TEXT * 0.6)
	combo_label.text     = ""

func _show_intro() -> void:
	feedback_label.text              = "press ENTER\n to begin"
	feedback_label.add_theme_color_override("font_color", C_TEXT)

# ─── INPUT ────────────────────────────────────────────────────────────────────
func _input(event: InputEvent) -> void:
	if not is_playing:
		if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
			_start_game()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_F:
				_attempt_hit(0)   # small squeeze
			KEY_J:
				_attempt_hit(1)   # big squeeze

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
		# mis-timed or empty squeeze — just sad, no penalty sound
		_show_feedback("MISS", C_BG)  # silent miss
		combo = 0
		combo_label.text = ""

# ─── GAME LOOP ────────────────────────────────────────────────────────────────
func _start_game() -> void:
	is_playing    = true
	song_time     = 0.0
	chart_index   = 0
	score         = 0
	combo         = 0
	misses        = 0
	slack_timer   = 5.0   # first slack message after 5s
	feedback_label.text = ""

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
	#_update_stress_ball(delta)
	_handle_slack()

	if feedback_timer <= 0.0:
		feedback_label.text = ""

	if song_time >= SONG_DURATION:
		_end_game()

func _spawn_notes() -> void:
	while chart_index < CHART.size():
		var entry      = CHART[chart_index]
		var beat_num   = entry[0]
		var note_type  = entry[1]
		var note_time  = beat_num * BEAT_SEC
		var look_ahead = 2.5  # seconds before note is needed, spawn it

		if note_time - song_time <= look_ahead:
			# Randomise appearance by shifting when the note spawns into view.
			# The hit time stays fixed — only the travel start point shifts,
			# so notes arrive from different distances, feeling irregular.
			var jitter: float = randf_range(-0.9, 0.9)
			_create_note(note_time, note_type, jitter)
			chart_index += 1
		else:
			break
			break

func _create_note(beat_time: float, type: int, note_jitter: float) -> void:
	var lane_w: float = rhythm_lane.size.x
	var lane_h: float = rhythm_lane.size.y
	var word      := BUZZWORDS[randi() % BUZZWORDS.size()]

	# Use a Label as the note so the buzzword IS the note
	var note  = Label.new()
	note.text  = word
	note.add_theme_color_override("font_color", C_NOTE_BIG if type == 1 else C_NOTE_SMALL)
	note.add_theme_font_size_override("font_size", 25 if type == 1 else 20)

	# Start at right edge of lane
	var start_x   := lane_w - 20.0
	var start_y   := lane_h * 0.25 if type == 0 else lane_h * 0.55
	note.position = Vector2(start_x , start_y) + rhythm_lane.position

	note_container.add_child(note)

	active_notes.append({
		"node":      note,
		"beat_time": beat_time,
		"type":      type,
		"hit":       false,
	})

func _scroll_notes(delta: float) -> void:
	# Notes travel left: distance = lookahead_window * lane_width / look_ahead_time
	var lane_w: float = rhythm_lane.size.x
	var speed: float  = (lane_w - 64.0) / 2.5   # pixels per second
	for note_data in active_notes:
		if not note_data["hit"]:
			note_data["node"].position.x -= speed * delta

func _cull_missed_notes() -> void:
	var to_remove: Array = []
	for note_data in active_notes:
		if note_data["hit"]:
			continue
		# Note has scrolled past hit zone and window expired
		if song_time > float(note_data["beat_time"]) + HIT_WINDOW:
			note_data["node"].queue_free()
			to_remove.append(note_data)
			misses       += 1
			combo         = 0
			combo_label.text = ""
			_show_feedback("", C_BG)

	for r in to_remove:
		active_notes.erase(r)

# ─── UI UPDATES ───────────────────────────────────────────────────────────────
func _update_lunch_clock() -> void:
	var mins  := int(lunch_remaining / 60.0)
	var secs  := int(lunch_remaining) % 60
	lunch_clock.text = "lunch: %02d:%02d" % [mins, secs]
	if lunch_remaining < 300:   # last 5 min — slightly more grey
		lunch_clock.add_theme_color_override("font_color", C_MISS)

#func _update_stress_ball(delta: float) -> void:
	#squeeze_scale = lerpf(squeeze_scale, 1.0, delta * 8.0)
	#var s         := Vector2(squeeze_scale, 2.0 - squeeze_scale)
	#stress_ball.scale = s
	#stress_ball.modulate = C_BALL.lerp(C_BALL_SQUEEZ, squeeze_scale - 1.0)

func _animate_squeeze() -> void:
	#squeeze_scale = 0.72   # squash horizontally, bulge vertically
	stress_ball.texture = load("res://taiko-minigame/Assets/taiko-squeeze.png")
	await get_tree().create_timer(0.5).timeout
	stress_ball.texture = load("res://taiko-minigame/Assets/taiko-loose.png")

func _handle_slack() -> void:
	var setslacksize = LabelSettings.new()
	setslacksize.set_font_size(25)
	$SlackMessage/SlackLabel.label_settings = setslacksize
	if slack_timer <= 0.0 and not slack_visible:
		slack_label.text  = "Boss: So.. per my last email..."
		slack_panel.show()
		slack_visible       = true
		slack_timer         = 25.0   # next one in 25s
	elif slack_timer <= 0.0 and slack_visible:
		slack_panel.hide()
		slack_visible       = false
		slack_timer         = 20.0

func _show_feedback(text: String, color: Color) -> void:
	feedback_label.text = text
	feedback_label.add_theme_color_override("font_color", color)
	feedback_timer      = 0.4

# ─── END STATE ────────────────────────────────────────────────────────────────
func _end_game() -> void:
	is_playing = false
	for note_data in active_notes:
		note_data["node"].queue_free()
	active_notes.clear()

	var accuracy := 0.0
	var total    := CHART.size()
	if total > 0:
		accuracy = float(total - misses) / float(total) * 100.0

	feedback_label.add_theme_color_override("font_color", C_TEXT)
	feedback_label.text = (
		"meeting over.\n\nyou hit %d%%\nof what was said.\n\nno one noticed." 
		% [int(accuracy)]
	)
