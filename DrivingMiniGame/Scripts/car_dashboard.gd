extends CharacterBody2D

var potholeHit
var tireHealth = 3
const SPEED = 600.0
var rotationSpeed = 120
@onready var DrivingWheel = $DrivingWheel

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	_rotate_wheel(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("pothole"):
		print("player hit pothole")
		tireHealth -= 1
		potholeHit = true

func _rotate_wheel(delta):
	if velocity.x < 0 and DrivingWheel.rotation_degrees >= -45:
		DrivingWheel.rotation_degrees = move_toward(DrivingWheel.rotation_degrees, -45, rotationSpeed * delta)
	elif velocity.x > 0 and DrivingWheel.rotation_degrees <= 45:
		DrivingWheel.rotation_degrees = move_toward(DrivingWheel.rotation_degrees, 45, rotationSpeed * delta)
	else:
		DrivingWheel.rotation_degrees = move_toward(DrivingWheel.rotation_degrees, 0, 200 * delta)
