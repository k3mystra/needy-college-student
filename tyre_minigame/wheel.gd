class_name Wheel extends RigidBody2D

var is_held : bool = false
var mouse_offset_x : float = 0.0
var broken : bool = true
var fixable : bool = false
signal fix_or_not(b:bool)
var fixed : bool = false

@export var drag_responsiveness : float = 5.0 
@onready var WheelPng : AnimatedSprite2D = $WheelPng

# PRELOAD SOUNDS HERE
var thud = preload("res://tyre_minigame/sounds/wheel_impact.ogg")

func activate():
	input_pickable = true

func _ready() -> void:
	input_pickable = false

func _physics_process(delta: float) -> void:
	if broken == false and fixed == false:
		if global_position.x <= 100 and global_position.x >= -100:
			fixable = true
			fix_or_not.emit(fixable)
		else:
			fix_or_not.emit(fixable)
	if is_held:
		linear_velocity.y = 0
		var target_x = get_global_mouse_position().x - mouse_offset_x
		var distance_x = target_x - global_position.x
		linear_velocity.x = distance_x * drag_responsiveness

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			get_viewport().set_input_as_handled()
			is_held = true
			mouse_offset_x = get_global_mouse_position().x - global_position.x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		is_held = false

func goes_into_screen_from_right_toleft():
	linear_velocity.x = -500
func attach() -> void:
	fixed = true
	freeze = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	
	var tween = get_tree().create_tween()
	
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "global_position", Vector2.ZERO, 0.4)

	tween.parallel().tween_property(self, "rotation", 0.0, 0.4)
	tween.tween_callback(_on_attachment_complete)
	

func _on_attachment_complete() -> void:
	print("Wheel attached successfully!")


func _on_impact_checker_body_entered(body: Node2D) -> void:
	play_sound(thud, randf_range(0.6, 2), 1)
	
func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	p.global_position = global_position
	get_tree().current_scene.add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
