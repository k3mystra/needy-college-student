extends Node2D

@export var cooldown: float
@export var timer: float
@export var x_range : float
@export var y_range : float
@onready var circle = $WordHolder
@onready var OuterCircle = $WordHolder/WordHolderCircle
@onready var word = $WordHolder/Word
var letter = ["w", "a", "s", "d", "q", "e", "r", "f", "z", "x"]
var letter_amount : int
var allow_count = true
var prevpos : Vector2
var anim_timer = 0.8

func _ready() -> void:
	letter_amount = letter.size()
	print ("TESTING: Letter chosen is, ", letter[randi_range(0, letter_amount - 1)])
	print (letter_amount)

func _process(delta: float) -> void:
	if allow_count:
		cooldown -= 1 * delta
		if cooldown < 0:
			_start()
	anim_timer -= 1 * delta
	if anim_timer < 0:
		_animation()
		anim_timer = 0.1

func _start():
	allow_count = false
	circle.global_position = Vector2(randf_range(-x_range, x_range), randf_range(-y_range, y_range))
	prevpos = circle.global_position
	var selected_word = letter[randi_range(0, letter_amount - 1)]
	print ("selected_word is ", selected_word)
	word.text = selected_word.to_upper()
	allow_count = true
	cooldown = 1

func _animation():
	circle.global_position.x = prevpos.x + randf_range(-6, 6)
	circle.global_position.y = prevpos.y + randf_range(-6, 6)
	circle.rotation_degrees = 0 + randf_range(-15, 15)
