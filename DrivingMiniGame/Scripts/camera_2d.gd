extends Camera2D

var randomStrength = 30.0
var shakeFade = 5.0

var rng = RandomNumberGenerator.new()
var shakeStrength = 0.0

var shakeCamera = false
var shakeTimer: float
var shakeDuration = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shakeCamera:
		_apply_shake()
		shakeTimer += delta
		
		if shakeTimer >= shakeDuration:
			shakeCamera = false
			shakeTimer = 0
		
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
		offset = _random_offset()

func _apply_shake():
	shakeStrength = randomStrength

func _random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
