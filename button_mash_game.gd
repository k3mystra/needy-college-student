extends Node2D

@export var cooldown: float
@export var timer: float
@onready var circle = $WordHolder
@onready var OuterCircle = $WordHolder/WordHolderCircle
@onready var word = $WordHolder/Word
var letter = ["w", "a", "s", "d", "q", "e", "r", "f", "z", "x"]
var letter_amount : int
var allow_count = true

func _ready() -> void:
	letter_amount = letter.size()
	print ("TESTING: Letter chosen is, ", letter[randi_range(0, letter_amount - 1)])
	print (letter_amount)

func _process(delta: float) -> void:
	if allow_count:
		cooldown -= 1 * delta
		if cooldown < 1:
			_start()
	

func _start():
	allow_count = false
	var selected_word = letter[randi_range(0, letter_amount - 1)]
	print ("selected_word is ", selected_word)
	word.text = selected_word.to_upper()
	allow_count = true
	cooldown = 2
