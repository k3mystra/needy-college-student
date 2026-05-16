class_name PC extends Node2D

@onready var blackscreen = $BlackScreen

var active : bool = false

signal turn_on

func _on_button_button_up() -> void:
	if active == false:
		active = true
		$pc.frame = 1
		$Area2D.remove_from_group("MonitorBugs")
		var tween = create_tween()
		tween.tween_property($BlackScreen, "modulate:a", 0.0, 
		1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		turn_on.emit()
