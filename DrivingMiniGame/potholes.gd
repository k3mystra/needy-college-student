extends Area2D

func _process(delta):
	position.y += 200 * delta
	scale += Vector2(2, 2) * delta
	
	if position.y >= 1000:
		queue_free()
