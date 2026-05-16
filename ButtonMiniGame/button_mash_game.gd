extends Node2D

@export var cooldown: float
@export var spam_cooldown : float
@export var timer: float
@export var x_range : float
@export var y_range : float
@export var button_spam_limit : int
@export var total_time : float

@onready var circle = $WordHolder
@onready var word = $WordHolder/Word
@onready var slider = $sliderholder/HSlider
@onready var sliderholder = $sliderholder
@onready var clock = $AudioStreamPlayer2D
@onready var bloodParticle = $sliderholder/HSlider/blood
@onready var particle = $CPUParticles2D


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
var prev_total_time : float
var intensity = 0.0
# replace the spam button to the things taht come from the side of the screen

var button_spam = preload("res://ButtonMiniGame/button_spam.tscn")

#PRELAOD SOUNDS HERE
var bell = preload("res://ButtonMiniGame/sounds/bell.ogg")
var ping = preload("res://ButtonMiniGame/sounds/ping.ogg")
var wrong = preload("res://ButtonMiniGame/sounds/wrong.ogg")
var glass = preload("res://ButtonMiniGame/sounds/break.ogg")


func _ready() -> void:
	circle.hide()
	circle.self_modulate = Color("00ff00")
	letter_amount = letter.size()
	print ("TESTING: Letter chosen is, ", letter[randi_range(0, letter_amount - 1)])
	print (letter_amount)
	prevtimer = timer
	prevcooldown = cooldown
	prevspamcooldown = spam_cooldown
	prevsliderpos = sliderholder.position
	prev_total_time = total_time
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
		particle.emitting = true
		_clock_sound()
		circle.show()
		_maintimer()
	
	if intensity > 0.1:
		intensity = lerpf(intensity, 0.0, delta * 8)
		sliderholder.position = prevsliderpos + Vector2(
			randf_range(-intensity, intensity), 
			randf_range(-intensity, intensity))
		sliderholder.rotation_degrees = randf_range(-8.0, 8.0) * (intensity / 35.0)
	else:
		intensity = 0.0
		sliderholder.position = prevsliderpos
		sliderholder.rotation_degrees = 0.0
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

	if (total_time < prev_total_time/2 + 45):
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

	total_time -= 1 * delta
	_showtime(total_time)
	_border()
	_follow_word()


func _spawn_spam():
	var spawnpoint = $spawn
	var button = button_spam.instantiate()
	if randi_range(0, 1) == 0:
		spawnpoint.position = Vector2(-896, randf_range(-384, 384))
		button.dir = 0
	else:
		spawnpoint.position = Vector2(896, randf_range(-384, 384))
		button.dir = 1
	button.global_position = spawnpoint.global_position
	get_parent().add_child(button)


func _start():
	allow_count = false
	circle.position = Vector2(randf_range(-x_range, x_range), randf_range(-y_range, y_range))
	prevpos = circle.position
	selected_word = letter[randi_range(0, letter_amount - 1)]
	print ("selected_word is ", selected_word)
	word.text = selected_word.to_upper()

func _maintimer():
	if timer > 0:
		timer -= 1 * get_process_delta_time()
		var target_color = remap(timer, 2, 0.0, 0.0, 4.99)
		circleColor = int(floor(target_color))
	else:
		particle.emitting = false
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
				_slider_damage(15)
				timer -= 0.5
				print ("OOPS")

func _resultcheck(result: bool):
	circle.hide()
	if result:
		play_sound(ping, 1, 1)
		_slider_damage(-10)
		allow_count = true
		timer = prevtimer - 0.65
		cooldown = prevcooldown + randf_range(-0.35, 0.2)
		print ("GOOD EVERYTHING IS GOOD")
	else:
		play_sound(bell, 1, 3)
		_slider_damage(45)
		allow_count = true
		timer = prevtimer
		cooldown = prevcooldown + randf_range(-0.5, 0)
		print ("NO BUTTON PRESSED AND RAN OUT OF TIME")

func _animation():
	circle.position.x = prevpos.x + randf_range(-6, 6)
	circle.position.y = prevpos.y + randf_range(-6, 6)
	circle.rotation_degrees = randf_range(-15, 15)

func _slider_damage(value: float):
	slider.value += value
	
	if value > 0:
		play_sound(glass, 1, 6)
		bloodParticle.emitting = true
		intensity = 35.0 
	else:
		intensity = 0.0


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

func _border():
	var border = $CanvasLayer/vignette
	var targetAlpha = remap(slider.value, 0.0, 150.0, 0.0, 0.6)
	border.self_modulate.a = targetAlpha

func _buttonspamW():
	_slider_damage(-7)

func _buttonspamL():
	bloodParticle.emitting = true
	_slider_damage(45)

func _follow_word():
	particle.position = circle.position

func _showtime(seconds: float):
	var time = $sliderholder/time
	time.text = str(int(seconds))
