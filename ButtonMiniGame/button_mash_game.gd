extends Node2D

@export var cooldown: float
@export var spam_cooldown : float
@export var timer: float
@export var x_range : float
@export var y_range : float
@export var button_spam_limit : int

@onready var circle = $WordHolder
@onready var word = $WordHolder/Word
@onready var slider = $sliderholder/HSlider
@onready var sliderholder = $sliderholder
@onready var clock = $AudioStreamPlayer2D

var letter = ["w", "a", "s", "d", "q", "e", "r", "f", "z", "x", "c"]
var letter_amount : int
var allow_count = true
var prevpos : Vector2
var anim_timer = 0.8
var circleColor = 0
var prevtimer = 0.0
var prevcooldown = 0.0
var prevspamcooldown = 0.0
var prevsliderpos : Vector2
var selected_word : String


var button_spam = preload("res://ButtonMiniGame/button_spam.tscn")

#PRELAOD SOUNDS HERE
var bell = preload("res://ButtonMiniGame/sounds/bell.ogg")
var ping = preload("res://ButtonMiniGame/sounds/ping.ogg")
var wrong = preload("res://ButtonMiniGame/sounds/wrong.ogg")


func _ready() -> void:
	circle.hide()
	circle.self_modulate = Color("00ff00")
	letter_amount = letter.size()
	print ("TESTING: Letter chosen is, ", letter[randi_range(0, letter_amount - 1)])
	print (letter_amount)
	prevtimer = timer
	prevcooldown = cooldown
	prevspamcooldown = spam_cooldown
	prevsliderpos = sliderholder.global_position
	Global.buttonspam_L.connect(_buttonspamL)
	Global.buttonspam_W.connect(_buttonspamW)

func _process(delta: float) -> void:
	if allow_count:
		clock.stop()
		cooldown -= 1 * delta
		if cooldown < 0:
			clock.play()
			_start()
	elif !allow_count:
		_clock_sound()
		circle.show()
		_maintimer()
		
	anim_timer -= 1 * delta
	if anim_timer < 0:
		_animation()
		anim_timer = 0.1
	match circleColor:
		0: circle.self_modulate = Color("00ff00")
		1: circle.self_modulate = Color("c1ff00")
		2: circle.self_modulate = Color("ffff00")
		3: circle.self_modulate = Color("ff8900")
		4: circle.self_modulate = Color("e3000d")

	spam_cooldown -= 1 * delta
	if spam_cooldown < 0:
		if Global.total_button_spam < button_spam_limit:
			_spawn_spam()
			spam_cooldown = prevspamcooldown + randf_range(-0.2, 0.1)
			button_spam_limit = 4
		else:
			if randi_range(0, 3) == 0:
				button_spam_limit += 1 
			spam_cooldown = prevspamcooldown + randf_range(-0.4, 0)


func _spawn_spam():
	var spawnpoint = $spawn
	spawnpoint.global_position = Vector2(randf_range(-1000, 1000), randf_range(-500, 500))
	var button = button_spam.instantiate()
	button.global_position = spawnpoint.global_position
	get_parent().add_child(button)


func _start():
	allow_count = false
	circle.global_position = Vector2(randf_range(-x_range, x_range), randf_range(-y_range, y_range))
	prevpos = circle.global_position
	selected_word = letter[randi_range(0, letter_amount - 1)]
	print ("selected_word is ", selected_word)
	word.text = selected_word.to_upper()

func _maintimer():
	if timer > 0:
		timer -= 1 * get_process_delta_time()
		var target_color = remap(timer, 2, 0.0, 0.0, 4.99)
		circleColor = int(floor(target_color))
	else:
		circle.hide()
		_resultcheck(false)

func _input(event: InputEvent) -> void:
	if !allow_count and timer > 0:
		if event is InputEventKey and event.pressed:
			var key_pressed = event.as_text().to_lower()
			if key_pressed in selected_word:
				_resultcheck(true)
			else:
				play_sound(wrong, 1, 2)
				_slider_damage(10)
				timer -= 0.5
				print ("OOPS")

func _resultcheck(result: bool):
	circle.hide()
	if result:
		play_sound(ping, 1, 1)
		_slider_damage(-10)
		allow_count = true
		timer = prevtimer - 0.65
		cooldown = prevcooldown
		print ("GOOD EVERYTHING IS GOOD")
	else:
		play_sound(bell, 1, 3)
		_slider_damage(25)
		allow_count = true
		timer = prevtimer
		cooldown = prevcooldown + randf_range(-0.4, 0)
		print ("NO BUTTON PRESSED AND RAN OUT OF TIME")

func _animation():
	circle.global_position.x = prevpos.x + randf_range(-6, 6)
	circle.global_position.y = prevpos.y + randf_range(-6, 6)
	circle.rotation_degrees = randf_range(-15, 15)

func _slider_damage(value: float):
	slider.value += value
	while value > 0:
		sliderholder.global_position = prevsliderpos
		sliderholder.global_position += Vector2(randf_range(-35, 35), randf_range(-35, 35))
		sliderholder.rotation_degrees = 0
		sliderholder.rotation_degrees += randf_range(-8, 8)
		value -= 3
		await get_tree().create_timer(0.05).timeout
	sliderholder.global_position = prevsliderpos
	sliderholder.rotation_degrees /= 2

func play_sound (stream: AudioStream, pitch: float, volume: float): # YOU CAN JUST COPY AND PASTE THIS
	var p = AudioStreamPlayer2D.new() # make new audioplayer
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p) # adds to the world
	p.play() # play first
	p.finished.connect(p.queue_free) # remove itself after finished playing

func _clock_sound():
	var target_pitch = remap(timer, 2, 0, 1, 2)
	clock.pitch_scale = target_pitch
	

func _buttonspamW():
	_slider_damage(-7)

func _buttonspamL():
	_slider_damage(20)
