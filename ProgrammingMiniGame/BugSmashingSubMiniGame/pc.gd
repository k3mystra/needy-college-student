class_name PC extends Node2D

@onready var blackscreen = $BlackScreen

var active : bool = false

signal turn_on

# PRELOAD SOUNDS HERE
var buttondown = preload("res://ProgrammingMiniGame/sounds/button-down.ogg")
var buttonup = preload("res://ProgrammingMiniGame/sounds/button-up.ogg")
var startup = preload("res://ProgrammingMiniGame/sounds/powerup.ogg")

func _on_button_button_up() -> void:
	if active == false:
		play_sound(buttonup, 1, 1)
		active = true
		$pc.frame = 1
		$Area2D.remove_from_group("MonitorBugs")
		play_sound(startup, 1.5, 1)
		var tween = create_tween()
		tween.tween_property($BlackScreen, "modulate:a", 0.0, 
		1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		turn_on.emit()

func play_sound (stream: AudioStream, pitch: float, volume: float):
	var p = AudioStreamPlayer2D.new()
	p.stream = stream
	p.pitch_scale = pitch
	p.volume_db = 2 + volume
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)

func _on_button_button_down() -> void:
	play_sound(buttondown, 1, 1)
