extends Node2D

@export var cooldown: float
@export var timer: float
@export var x_range : float
@export var y_range : float
@onready var circle = $WordHolder
@onready var word = $WordHolder/Word
var letter = ["w", "a", "s", "d", "q", "e", "r", "f", "z", "x"]
var letter_amount : int
var allow_count = true
var prevpos : Vector2
var anim_timer = 0.8
var circleColor = 0
var prevtimer = 0.0
var prevcooldown = 0.0
var selected_word : String


func _ready() -> void:
	circle.self_modulate = Color("00ff00")
	letter_amount = letter.size()
	print ("TESTING: Letter chosen is, ", letter[randi_range(0, letter_amount - 1)])
	print (letter_amount)
	prevtimer = timer
	prevcooldown = cooldown

func _process(delta: float) -> void:
	if allow_count:
		cooldown -= 1 * delta
		if cooldown < 0:
			_start()
	elif !allow_count:
		show()
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
		hide()
		_resultcheck(false)

func _input(event: InputEvent) -> void:
	if !allow_count and timer > 0:
		if event is InputEventKey and event.pressed:
			var key_pressed = event.as_text().to_lower()
			if key_pressed in selected_word:
				_resultcheck(true)
			else:
				timer -= 0.5
				print ("OOPS")
	else:
		pass

func _resultcheck(result: bool):
	hide()
	if result:
		allow_count = true
		timer = prevtimer
		cooldown = prevcooldown
		print ("GOOD EVERYTHING IS GOOD")
	else:
		allow_count = true
		timer = prevtimer
		cooldown = prevcooldown + randf_range(-0.3, 0.3)
		print ("NO BUTTON PRESSED AND RAN OUT OF TIME")

func _animation():
	circle.global_position.x = prevpos.x + randf_range(-6, 6)
	circle.global_position.y = prevpos.y + randf_range(-6, 6)
	circle.rotation_degrees = 0 + randf_range(-15, 15)
