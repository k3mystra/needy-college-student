class_name code_bug extends CharacterBody2D

var mouse_in : bool = false
@export var speed : float
@export var timer : float

@onready var animation = $AnimationPlayer
@onready var sound_loop = $loop

# PRELOAD SOUNDS HERE
var spawn = preload("res://ProgrammingMiniGame/sounds/bugspawn.ogg")
var die = preload("res://ProgrammingMiniGame/sounds/bugdie.ogg")

func _ready() -> void:
	play_sound(spawn, randf_range(1, 1.6), -15)
	sound_loop.pitch_scale = randf_range(0.7, 1.6)
	pass

func _physics_process(delta: float) -> void:
	timer -= 1 * delta
	if timer < 0:
		rotation += randf_range(-30, 30)
		timer = 0.1 + randf_range(0, 1)
	var forward_direction = Vector2.UP.rotated(rotation)
	velocity += forward_direction * speed / 2
	move_and_slide()

func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	p.global_position = global_position
	get_tree().current_scene.add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released(): 
			if mouse_in:
				play_sound(die, randf_range(0.5, 1.6), 3)
				ProgrammingMiniGameSignal.bug_smashed.emit()
				queue_free()
			
func _on_area_2d_mouse_entered() -> void:
	mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
