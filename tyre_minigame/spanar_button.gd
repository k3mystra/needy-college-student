extends TextureButton

var original_position : Vector2

func _ready() -> void:
	original_position = global_position

func _on_mouse_entered() -> void:
	ProgrammingMiniGameSignal.cursor_in.emit()
	
func _on_mouse_exited() -> void:
	ProgrammingMiniGameSignal.cursor_out.emit()

#I want a function that animates the the spanar button appearing, I want it to be a little bit elastic
func animate_appear() -> void:
# 1. Teleport it straight down (400 pixels lower, completely off-screen)
	position = original_position + Vector2(0, 400)
	scale = Vector2.ZERO # Start invisible
	show() 
	
	# 2. Create the animator and run animations simultaneously
	var tween = create_tween().set_parallel(true)
	
	# 3. The magic combination for a crisp, springy jump-up animation
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	
	# 4. Shoot it straight up to its home position and grow the scale over 0.5 seconds
	tween.tween_property(self, "position", original_position, 0.1)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.1)
