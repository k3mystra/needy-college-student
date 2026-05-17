extends Node

enum memory_pick_state { SWITCHING, IDLE, END }

@export var memory_data_array: Array[MemoryData]
@export var memory_scene: PackedScene

const MEMORY_SPRITE_HALF_WIDTH = 300

@onready var screen_size = get_viewport().get_visible_rect().size

var memory_index = 0
var current_state = memory_pick_state.SWITCHING
var current_memory
signal minigame_finished

func _ready() -> void:
	cycle_memory()


func _on_keep_btn_pressed() -> void:
	if current_state != memory_pick_state.IDLE:
		return

	if !current_memory.get_is_memory_wanted():
		# Call dialog to give impression that the character want to discard the memory
		resist_action()
		return

	var tween = get_tree().create_tween()
	tween.tween_property(current_memory, "position", Vector2(0 - MEMORY_SPRITE_HALF_WIDTH - 300, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_QUINT)
	cycle_memory()


func _on_discard_btn_pressed() -> void:
	if current_state != memory_pick_state.IDLE:
		return

	if current_memory.get_is_memory_wanted():
		# Call dialog to give impression that the character want to keep the memory
		resist_action()
		return

	current_memory.fade()
	cycle_memory()


func cycle_memory() -> void:
	current_state = memory_pick_state.SWITCHING
	var memory_instance = memory_scene.instantiate()
	memory_instance.position = Vector2(screen_size.x + MEMORY_SPRITE_HALF_WIDTH + 300, screen_size.y / 2)
	memory_instance.set_memory_data(memory_data_array[memory_index])
	current_memory = memory_instance
	add_child(memory_instance)

	# Animate position to center of screen
	var tween = get_tree().create_tween()
	tween.tween_property(memory_instance, "position", Vector2(screen_size.x / 2, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_QUINT)

	memory_index += 1

	if memory_index == memory_data_array.size():
		end_game()


func resist_action() -> void:
	current_memory.shake()


func end_game() -> void:
	current_state = memory_pick_state.END
	minigame_finished.emit()
