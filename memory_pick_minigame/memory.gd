extends CharacterBody2D

var is_wanted: bool

var rng = RandomNumberGenerator.new()

@export var shake_max_offset: float = 5
@export var shake_movement_amount: int = 10
@export var shake_duration: float = 2

const SHAKE_ANIM_NAME: String = "shake"
const MEMORY_ANIMATION_LIB_NAME: String = "memory_animations"


func _ready() -> void:
	var shake_anim = Animation.new()
	var track_index = shake_anim.add_track(Animation.TYPE_VALUE)

	shake_anim.track_set_path(track_index, "Sprite:position")

	var key_timespan = shake_duration / shake_movement_amount
	for i in range(shake_movement_amount + 1):
		var offset = Vector2(
			rng.randf_range(-shake_max_offset, shake_max_offset),
			rng.randf_range(-shake_max_offset, shake_max_offset)
		)
		shake_anim.track_insert_key(track_index, i * key_timespan, offset)

	shake_anim.length = shake_duration

	# From AnimationMixer
	# AnimationMixer (and its subclass) have a global library by default named ""
	# But that doesn't work for some reason
	var memory_anim_library = $AnimationPlayer.get_animation_library(MEMORY_ANIMATION_LIB_NAME)
	memory_anim_library.add_animation(SHAKE_ANIM_NAME, shake_anim)
	ResourceSaver.save(shake_anim, "shake_animation.tres", 1)


func set_memory_data(memory_data: MemoryData) -> void:
	$Sprite.texture = memory_data.sprite
	is_wanted = memory_data.is_wanted


func get_is_memory_wanted() -> bool:
	return is_wanted


func shake() -> void:
	# Apparently you have to refer to the animation by its library too, like a folder
	$AnimationPlayer.play(MEMORY_ANIMATION_LIB_NAME + "/" + SHAKE_ANIM_NAME)
