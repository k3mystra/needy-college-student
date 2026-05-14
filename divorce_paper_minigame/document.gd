extends CharacterBody2D

var sign_position: Vector2


func set_doc_data(doc_data: DocumentData) -> void:
	$Sprite.texture = doc_data.sprite
	sign_position = doc_data.sign_position


func play_signing_anim() -> void:
	$SigningAnim.position = sign_position
