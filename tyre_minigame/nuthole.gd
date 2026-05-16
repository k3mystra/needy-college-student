class_name nuthole extends Area2D

var active = false

func _on_body_entered(body: Node2D) -> void:
	if active == false:
		return
	if body is Nut:
		body.assign_nuthole(self)
		
func _on_body_exited(body: Node2D) -> void:
	if active == false:
		return
	if body is Nut:
		body.remove_nuthole()
