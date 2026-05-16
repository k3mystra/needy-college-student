class_name Nut extends RigidBody2D

@export var rotations_required: float = 3.0 # How many full circles to remove it
var total_rotation_accumulated: float = 0.0

var is_held: bool = false
var last_mouse_angle: float = 0.0
var detached : bool = false

var fix_wheel = false

var mouse_offset : Vector2 = Vector2.ZERO
var drag_responsiveness : float = 25.0

var complete = false

func _ready() -> void:
	freeze = true
	input_pickable = true

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
				Global.one_nut_reattached.emit()
				$CPUParticles2D.emitting = true		
					
	if is_held and detached:
		var target_pos = get_global_mouse_position() - mouse_offset
		var distance = target_pos - global_position
		linear_velocity = distance * drag_responsiveness

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			get_viewport().set_input_as_handled()
			is_held = true
			last_mouse_angle = global_position.angle_to_point(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released() and is_held == true:
		print(67)
		is_held = false
		ProgrammingMiniGameSignal.cursor_out.emit()
		
	if is_held == false:
		if nut_hole != null:
			attach()

func detach_and_fall() -> void:
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
		print("fuck")
		ProgrammingMiniGameSignal.cursor_out.emit()
