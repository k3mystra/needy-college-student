extends CharacterBody2D

var sign_position: Vector2
var sign_points: Array[Vector2]

enum DocState { PEN_DOWN, IDLE}

var current_doc_state: DocState = DocState.IDLE
var points


func _draw() -> void:
	if sign_points.size() < 2:
		return

	# Literally redraw everything every redraw call
	# Not performant but fk it
	for i in range(sign_points.size() - 1):
		var curr_point = sign_points[i]
		var next_point = sign_points[i + 1]

		draw_line(curr_point, next_point, Color.BLACK, 4.0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed(): current_doc_state = DocState.PEN_DOWN
		if event.is_released(): current_doc_state = DocState.IDLE
	elif event is InputEventMouseMotion:
		match current_doc_state:
			DocState.IDLE:
				return
			DocState.PEN_DOWN:
				# event.position is viewport-coordinate, need to substract our position to get local coordinate
				# since draw_line() accepts local coords
				sign_points.append(event.position - position)
				# print("Drawing", sign_points[-2], sign_points[-1])
				queue_redraw()
	else:
		return
