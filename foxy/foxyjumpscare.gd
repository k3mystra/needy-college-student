extends Control
@export var chance : int

@onready var animation = $AnimatedSprite2D
@onready var jumpscare = $AudioStreamPlayer2D

var timer = 1
var rand_chance : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	animation.animation_finished.connect(_on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= 1 * delta
	if timer < 0:
		rand_chance = randi_range(1, chance)
		if rand_chance == 1:
			_jumpscare()
		timer = 1

func _jumpscare():
	show()
	animation.play("default")
	jumpscare.play()

func _on_animation_finished():
	hide()
