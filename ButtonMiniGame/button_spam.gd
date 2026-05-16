extends Node2D
@export var max_distance : float
@export var dir : int
@export var timer = 0.6
@export var speed = 25

@onready var hand = $resize/Hand
@onready var animation = $AnimationPlayer
@onready var arm = $resize/arm
@onready var palm = $resize/hand

var handcolor = 0
var prev_timer = 0.0
var total_move : float

# Track starting positions on both axes
var start_pos_x : float
var start_pos_y : float

# PRELOAD SOUNDS HERE
var grow = preload("res://ButtonMiniGame/sounds/grow.ogg")
var shrink = preload("res://ButtonMiniGame/sounds/shrink.ogg")

func _ready() -> void:
	_animation_random(randi_range(0, 3))
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
	elif dir == 2: # up (starts high, moves down)
		rotation_degrees = 90
		position.y += randf_range(0, 45)
	elif dir == 3: # down (starts low, moves up)
		rotation_degrees = -90
		position.y -= randf_range(0, 45)
		
	# Store the starting positions exactly where they spawned
	start_pos_x = position.x
	start_pos_y = position.y

func _process(delta: float) -> void:
	# 1. Color Application Logic
	match handcolor:
		0: hand.self_modulate = Color("00ff00")
		1: hand.self_modulate = Color("c1ff00")
		2: hand.self_modulate = Color("ffff00")
		3: hand.self_modulate = Color("ff8900")
		4: hand.self_modulate = Color("e3000d")
		
	# 2. Distance Traveled Calculation (Axis Dependent)
	var distance_traveled : float = 0.0
	if dir == 0 or dir == 1:
		distance_traveled = abs(position.x - start_pos_x)
	elif dir == 2 or dir == 3:
		distance_traveled = abs(position.y - start_pos_y)
		
	var target_color = remap(distance_traveled, 0, max_distance, 0, 4.99)
	handcolor = int(floor(target_color))
	
	# 3. Automated Movement Timer
	timer -= 1 * delta
	if timer < 0:
		play_sound(grow, 0.5, 0.2)
		if dir == 0:
			position.x += speed
		elif dir == 1:
			position.x -= speed
		elif dir == 2: # Moves down (positive Y)
			position.y += speed
		elif dir == 3: # Moves up (negative Y)
			position.y -= speed
		timer = prev_timer
		
	# 4. Lose Condition: Reached Max Distance
	if distance_traveled > max_distance:
		print("Reached max distance!", position)
		Global.buttonspam_L.emit()
		Global.total_button_spam -= 1
		queue_free()
	
	# 5. Win Conditions: Pushed back past starting line
	if dir == 0 and position.x < start_pos_x:
		_success()
	elif dir == 1 and position.x > start_pos_x:
		_success()
	elif dir == 2 and position.y < start_pos_y: # Pushed back upwards past start
		_success()
	elif dir == 3 and position.y > start_pos_y: # Pushed back downwards past start
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
	elif dir == 2: # Push it back UP (negative Y)
		position.y -= 75
	elif dir == 3: # Push it back DOWN (positive Y)
		position.y += 75

func _animation_random(random: int):
	match random:
		0: animation.play("black-fist")
		1: animation.play("black-hand")
		2: animation.play("white-fist")
		3: animation.play("white-hand")

func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)
