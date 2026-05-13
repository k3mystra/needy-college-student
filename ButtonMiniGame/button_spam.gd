extends Node2D
@export var max_size : float
@onready var circle = $resize/Button
@onready var circle_size = $resize
var circleColor = 0
var speed = 0.2
var timer = 0.6
var prev_timer = 0.0
var cur_scale : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.total_button_spam += 1
	speed += randf_range(-0.1, 0.1)
	timer += randf_range(-0.15, 0.6)
	var rand_scale = randf_range(0, 0.4)
	circle_size.scale += Vector2(rand_scale, rand_scale)
	prev_timer = timer
	cur_scale = circle_size.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match circleColor:
		0: circle.self_modulate = Color("00ff00")
		1: circle.self_modulate = Color("c1ff00")
		2: circle.self_modulate = Color("ffff00")
		3: circle.self_modulate = Color("ff8900")
		4: circle.self_modulate = Color("e3000d")
	var target_color = remap(circle_size.scale.x, cur_scale, max_size, 0.0, 4.0)
	circleColor = int(ceil(target_color))
	timer -= 1 * delta
	if timer < 0:
		circle_size.scale += Vector2(speed, speed)
		timer = prev_timer
	if circle_size.scale.x > max_size:
		queue_free()
		Global.total_button_spam -= 1
		Global.buttonspam_L.emit()
	elif circle_size.scale.x < 0.4:
		queue_free()
		Global.total_button_spam -= 1
		Global.buttonspam_W.emit()

func _on_button_pressed() -> void:
	circle_size.scale -= Vector2(0.4, 0.4)
