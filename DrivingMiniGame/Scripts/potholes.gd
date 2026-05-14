extends Area2D

var CarDashboard 

func _process(delta):
	position.y += 200 * delta
	_move_towards(delta)
	scale += Vector2(2, 2) * delta
	
	if position.y >= 1000:
		queue_free()
		
func _move_towards(delta):
	if position.x < CarDashboard.global_position.x:
		position.x -= 100 * delta
	elif position.x > CarDashboard.global_position.x:
		position.x += 100 * delta
