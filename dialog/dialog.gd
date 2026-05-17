extends CanvasLayer

@export var dialogue: Array[String]
@export var speed: float = 20


enum DialogueState { TYPING, IDLE }

var index: int = 0
var time_per_char = 1.0 / speed
var current_tween: Tween
var state = DialogueState.IDLE


func _ready() -> void:
	play_dialogue()


func play_dialogue() -> void:
	state = DialogueState.TYPING

	var text_node = get_node("%Text")
	text_node.visible_ratio = 0
	text_node.text = dialogue[index]

	var total_time = time_per_char * dialogue[index].length()

	current_tween = get_tree().create_tween()
	current_tween.tween_property(text_node, "visible_ratio", 1.0, total_time)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog"):
		match state:
			DialogueState.TYPING:
				current_tween.pause()
				current_tween.custom_step(10000)
				state = DialogueState.IDLE
			DialogueState.IDLE:
				index += 1
				play_dialogue()
