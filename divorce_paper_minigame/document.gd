extends CharacterBody2D

var sign_position: Vector2
var sign_points: Array[Vector2]

enum DocState { PEN_DOWN, IDLE}

var current_doc_state: DocState = DocState.IDLE
var points
var mouse_speed : float

@onready var loop = $loop

# PRELOAD SOUNDS HERE
var down = preload("res://divorce_paper_minigame/sounds/pen_down.ogg")

func _process(delta: float) -> void:
	if mouse_speed > 0:
		mouse_speed = lerpf(mouse_speed, 0.0, delta * 10.0)
		var target_pitch = remap(mouse_speed, 0, 400, 0.1, 1)
		loop.pitch_scale = target_pitch

func _draw() -> void:
	if sign_points.size() < 2:
		return

	# Literally redraw everything every redraw call
	# Not performant but fk it
	for i in range(sign_points.size() - 1):
		var curr_point = sign_points[i]
		var next_point = sign_points[i + 1]

		draw_line(curr_point, next_point, Color.BLACK, 4.0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			current_doc_state = DocState.PEN_DOWN
			play_sound(down, 1.5, 1)
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
				mouse_speed = event.velocity.length()
				# event.position is viewport-coordinate, need to substract our position to get local coordinate
				# since draw_line() accepts local coords
				loop.global_position = get_global_mouse_position()
				sign_points.append(event.position - position)
				# print("Drawing", sign_points[-2], sign_points[-1])
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
