extends Node2D
@export var max_distance : float
@export var dir : int
@export var timer = 0.6
@export var speed = 25

@onready var hand = $resize/Hand

var handcolor = 0
var prev_timer = 0.0
var prev_posX = 0.0
var total_move : float

#PRELAOD SOUNDS HERE
var grow = preload("res://ButtonMiniGame/sounds/grow.ogg")
var shrink = preload("res://ButtonMiniGame/sounds/shrink.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.total_button_spam += 1
	speed += randf_range(-5, 35)
	timer += randf_range(-0.15, 0.6)
	prev_timer = timer
	if dir == 0:
		scale.x = 1
		position.x += randf_range(0, 180)
	elif dir == 1:
		scale.x = -1
		position.x -= randf_range(0, 180)
	prev_posX = position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match handcolor:
		0: hand.self_modulate = Color("00ff00")
		1: hand.self_modulate = Color("c1ff00")
		2: hand.self_modulate = Color("ffff00")
		3: hand.self_modulate = Color("ff8900")
		4: hand.self_modulate = Color("e3000d")
	var distance_traveled = abs(position.x - prev_posX)
	var target_color = remap(distance_traveled, 0, max_distance, 0, 4)
	handcolor = int(ceil(target_color))
	timer -= 1 * delta
	if timer < 0:
		play_sound(grow, 0.5, 0.2)
		if scale.x == 1:
			position.x += speed
		elif scale.x == -1:
			position.x -= speed
		total_move += speed
		timer = prev_timer
	if distance_traveled > max_distance:
		print("Reached max distance!", position.x)
		Global.buttonspam_L.emit()
		Global.total_button_spam -= 1
		queue_free()
	
	if dir == 0 and position.x < prev_posX:
		_success()
	elif dir == 1 and position.x > prev_posX:
		_success()

func _success():
	Global.buttonspam_W.emit()
	Global.total_button_spam -= 1
	queue_free()

func _on_button_pressed() -> void:
	play_sound(shrink, 2, 5)
	if dir == 0:
		position.x -= 75
	elif dir == 1:
		position.x += 75



func play_sound (stream: AudioStream, pitch: float, volume: float): # YOU CAN JUST COPY AND PASTE THIS
	var p = AudioStreamPlayer2D.new() # make new audioplayer
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p) # adds to the world
	p.play() # play first
	p.finished.connect(p.queue_free) # remove itself after finished playing
