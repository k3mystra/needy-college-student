extends CharacterBody2D

var sign_position: Vector2
var sign_strokes = []
var sign_rect: Rect2

var is_signed: bool = false
var points_in_sign_rect_count: int = 0

enum DocState { PEN_DOWN, IDLE}

var current_doc_state: DocState = DocState.IDLE
var mouse_speed : float
var rng = RandomNumberGenerator.new()

@export var stroke_width: float = 4.0

const PAPER_MARGIN: Transform2D = Transform2D(0.0, Vector2(0.8,0.8), 0.0, Vector2(0,0))
const MIN_POINTS_TO_SIGN: int = 20

# Shake animations
@export var shake_max_offset: float = 5
@export var shake_movement_amount: int = 10
@export var shake_duration: float = 2

const SHAKE_ANIM_NAME: String = "shake"
const DOC_ANIM_LIB: String = "document_anims"

@onready var loop = $loop

# PRELOAD SOUNDS HERE
var down = preload("res://divorce_paper_minigame/sounds/pen_down.ogg")


func _ready() -> void:
	calc_sign_box_rect()
	generate_shake_anim()


func calc_sign_box_rect() -> void:
	# Calculate bounding rect for the sign box
	var sign_box_size = Vector2(
		abs($SignBoxStart.position.x - $SignBoxEnd.position.x),
		abs($SignBoxStart.position.y - $SignBoxEnd.position.y)
	)

	sign_rect = Rect2($SignBoxStart.position, sign_box_size)


func generate_shake_anim() -> void:
	var shake_anim = Animation.new()
	var track_index = shake_anim.add_track(Animation.TYPE_VALUE)

	shake_anim.track_set_path(track_index, "Sprite:position")

	var key_timespan = shake_duration / shake_movement_amount
	for i in range(shake_movement_amount + 1):
		var offset = Vector2(
			rng.randf_range(-shake_max_offset, shake_max_offset),
			rng.randf_range(-shake_max_offset, shake_max_offset)
		)
		shake_anim.track_insert_key(track_index, i * key_timespan, offset)

	shake_anim.length = shake_duration

	# From AnimationMixer
	# AnimationMixer (and its subclass) have a global library by default named ""
	# But that doesn't work for some reason
	var memory_anim_library = $AnimationPlayer.get_animation_library(DOC_ANIM_LIB)
	memory_anim_library.add_animation(SHAKE_ANIM_NAME, shake_anim)


# Sound stuff
func _process(delta: float) -> void:
	if mouse_speed > 0:
		mouse_speed = lerpf(mouse_speed, 0.0, delta * 10.0)
		var target_pitch = remap(mouse_speed, 0, 300, 0.1, 1.5)
		loop.pitch_scale = clampf(target_pitch, 0.1, 1.5)


func _draw() -> void:
	for sign_points in sign_strokes:
		if sign_points.size() < 2:
			continue;

		# Literally redraw everything every redraw call
		# Not performant but fk it
		for i in range(sign_points.size() - 1):
			var curr_point = sign_points[i]
			var next_point = sign_points[i + 1]

			draw_line(curr_point, next_point, Color.BLACK, stroke_width)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			current_doc_state = DocState.PEN_DOWN
			play_sound(down, 1.5, 1)
			add_new_stroke()
		if event.is_released():
			current_doc_state = DocState.IDLE
			play_sound(down, -0.4, 1)
	elif event is InputEventMouseMotion:
		match current_doc_state:
			DocState.IDLE:
				loop.stop()
				return
			DocState.PEN_DOWN:
				loop.play()

				# If the fking pen got railed outside of paper
				# Get the pen up
				var local_pos = event.position - position
				var sprite_rect = $Sprite.get_rect() * $Sprite.transform * PAPER_MARGIN
				if (!sprite_rect.has_point(local_pos)):
					current_doc_state = DocState.IDLE
					return

				mouse_speed = event.velocity.length()
				# event.position is viewport-coordinate, need to substract our position to get local coordinate
				# since draw_line() accepts local coords
				loop.global_position = get_global_mouse_position()
				add_points_to_current_stroke(local_pos)
				queue_redraw()
	else:
		return


func play_sound (stream: AudioStream, pitch: float, volume: float): # YOU CAN JUST COPY AND PASTE THIS
	var p = AudioStreamPlayer2D.new() # make new audioplayer
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p) # adds to the world
	p.play() # play first
	p.finished.connect(p.queue_free) # remove itself after finished playing


func add_points_to_current_stroke(pos: Vector2) -> void:
	# Side Effect: set the document as signed if enough points within the sign box bounding rectum
	if sign_rect.has_point(pos):
		points_in_sign_rect_count += 1

	if points_in_sign_rect_count >= MIN_POINTS_TO_SIGN:
		is_signed = true

	sign_strokes[-1].append(pos)


func add_new_stroke() -> void:
	sign_strokes.append([])


func shake() -> void:
	$AnimationPlayer.play(DOC_ANIM_LIB + "/" + SHAKE_ANIM_NAME)
