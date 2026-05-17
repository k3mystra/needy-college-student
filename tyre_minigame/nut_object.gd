class_name Nut extends RigidBody2D

@export var rotations_required: float = 3.0 # How many full circles to remove it

@onready var turn = $turn
@onready var impactCheck = $impactcheck

var total_rotation_accumulated: float = 0.0

var is_held: bool = false
var last_mouse_angle: float = 0.0
var detached : bool = false

var fix_wheel = false

var mouse_offset : Vector2 = Vector2.ZERO
var drag_responsiveness : float = 25.0

var complete = false

# PRELOAD SOUNDS HERE
var nutDownUp = preload("res://tyre_minigame/sounds/nut-downup.ogg")
var impact = preload("res://tyre_minigame/sounds/impact.ogg")
var pop = preload("res://tyre_minigame/sounds/pop.ogg")

func _ready() -> void:
	freeze = true
	input_pickable = true
	impactCheck.monitoring = false

func _physics_process(delta: float) -> void:
	if is_held and freeze:
		var current_mouse_pos = get_global_mouse_position()
		var current_angle = global_position.angle_to_point(current_mouse_pos)
		
		var angle_diff = wrapf(current_angle - last_mouse_angle, -PI, PI)
		
		if fix_wheel == false:
			if angle_diff > 0:
				rotation += angle_diff
				total_rotation_accumulated += angle_diff
				
			last_mouse_angle = current_angle
			if total_rotation_accumulated >= (rotations_required * TAU):
				detach_and_fall()
				
		if fix_wheel == true and complete == false:
			if angle_diff < 0:
				rotation += angle_diff
				total_rotation_accumulated -= angle_diff
				
			last_mouse_angle = current_angle
			if total_rotation_accumulated >= (rotations_required * TAU):
				complete = true
				play_sound(nutDownUp, 0.7, 1)
				Global.one_nut_reattached.emit()
				$CPUParticles2D.emitting = true		
					
	if is_held and detached:
		var target_pos = get_global_mouse_position() - mouse_offset
		var distance = target_pos - global_position
		linear_velocity = distance * drag_responsiveness

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			turn.play()
			get_viewport().set_input_as_handled()
			is_held = true
			last_mouse_angle = global_position.angle_to_point(get_global_mouse_position())
		else:
			turn.stop()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and is_held == true:
		is_held = false
		turn.stop()
		ProgrammingMiniGameSignal.cursor_out.emit()
		
	if is_held == false:
		if nut_hole != null:
			attach()

func detach_and_fall() -> void:
	impactCheck.monitoring = true
	turn.stop()
	turn.volume_db = -150
	play_sound(pop, randf_range(0.4, 2), 1)
	detached = true
	is_held = false
	freeze = false 
	apply_impulse(Vector2(randf_range(-50, 50), -100))
	Global.nut_removed.emit()
	total_rotation_accumulated = 0

var nut_hole : nuthole

func assign_nuthole(nh :nuthole):
	nut_hole = nh

func remove_nuthole():
	nut_hole = null

func attach():
	if nut_hole != null:
		turn.volume_db = 0
		global_position = nut_hole.global_position
	
	sleeping = true
	freeze = true
	detached = false
	fix_wheel = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0 
	
func _mouse_enter() -> void:
	ProgrammingMiniGameSignal.cursor_in.emit()

func _mouse_exit() -> void:
	if is_held != true:
		ProgrammingMiniGameSignal.cursor_out.emit()

func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	p.global_position = global_position
	get_tree().current_scene.add_child(p)
	p.play()
	p.finished.connect(p.queue_free)


func _on_impactcheck_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(1):
		play_sound(impact, randf_range(2, 4), 1)
