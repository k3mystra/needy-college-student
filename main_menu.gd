extends Control

@export var intensity : float

@onready var label1 = $title/Label
@onready var label2 = $title/Label2
@onready var label3 = $title/Label3
@onready var label4 = $title/Label4

var prevpos_1 : Vector2
var prevpos_2 : Vector2
var prevpos_3 : Vector2
var prevpos_4 : Vector2
var timer = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prevpos_1 = label1.position
	prevpos_2 = label2.position
	prevpos_3 = label3.position
	prevpos_4 = label4.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # hard coding this shit cause i could care less
	timer -= 1 * delta
	print("time is ", timer)
	if timer < 0:
		label1.position = prevpos_1 + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		label2.position = prevpos_2 + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		label3.position = prevpos_3 + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		label4.position = prevpos_4 + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		label1.rotation_degrees = 0 + randf_range(-intensity, intensity)
		label2.rotation_degrees = 0 + randf_range(-intensity, intensity)
		label3.rotation_degrees = 0 + randf_range(-intensity, intensity)
		label4.rotation_degrees = 0 + randf_range(-intensity, intensity)
		timer = 0.1


func _on_play_pressed() -> void:
	pass # Replace with function body.
