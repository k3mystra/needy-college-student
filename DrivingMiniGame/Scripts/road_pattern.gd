extends Area2D

func _process(delta):
	position.y += 400 * delta
	scale += Vector2(16, 16) * delta
	
	if position.y >= 1000:
		queue_free()
