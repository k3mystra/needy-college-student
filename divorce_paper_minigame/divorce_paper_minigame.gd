extends Node2D

enum game_state { SWITCHING, IDLE, END }

@export var doc_data_array: Array[DocumentData]
@export var doc_scene: PackedScene

const DOC_SPRITE_HALF_WIDTH = 300

@onready var screen_size = get_viewport().get_visible_rect().size

var doc_index = 0
var current_state = game_state.SWITCHING
var current_doc: PackedScene


func _ready() -> void:
	cycle_doc()


func _on_sign_btn_pressed() -> void:
	if current_state != game_state.IDLE:
		return

	sign_document()
	cycle_doc()


func cycle_doc() -> void:
	current_state = game_state.SWITCHING
	var doc_instance = doc_scene.instantiate()
	doc_instance.position = Vector2(screen_size.x + DOC_SPRITE_HALF_WIDTH, screen_size.y / 2)
	doc_instance.set_doc_data(doc_data_array[doc_index])
	current_doc = doc_instance
	add_child(doc_instance)

	# Animate position to center of screen
	var tween = get_tree().create_tween()
	tween.tween_property(doc_instance, "position", Vector2(screen_size.x / 2, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_QUINT)

	doc_index += 1

	current_state = game_state.IDLE
	if doc_index == doc_data_array.size():
		end_game()


func sign_document() -> void:
	print("Document signed: " + str(doc_index))
	current_doc.play_signing_anim()

	# Animate position to off screen
	var tween = get_tree().create_tween()
	tween.tween_property(current_doc, "position", Vector2(0 - DOC_SPRITE_HALF_WIDTH, screen_size.y / 2), 1.0).set_trans(Tween.TRANS_QUINT)


func end_game() -> void:
	current_state = game_state.END
