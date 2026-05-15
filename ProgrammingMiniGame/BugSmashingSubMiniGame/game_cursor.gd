class_name game_cursor extends Node2D

func _ready() -> void:
	ProgrammingMiniGameSignal.cursor_in.connect(switch_hand)
	ProgrammingMiniGameSignal.cursor_out.connect(switch_normal)

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func switch_normal():
	$Mouse.offset = Vector2(0,0)
	$Mouse.play("default")

func switch_hand():
	$Mouse.offset = Vector2(-12,-2)
	$Mouse.play("Hand")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("MonitorBugs"):
		switch_hand()

func _on_area_2d_area_exited(area: Area2D) -> void:
	switch_normal()
