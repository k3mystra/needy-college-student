extends Node2D

@onready var wheel : Wheel = $Wheel
@onready var all_nuts : Node2D = $all_nuts
@onready var all_nut_hole : Array = $All_nuthole.get_children()

var moved_nut : int = 0
var nut_amount : int 

func _ready():
	nut_amount = all_nuts.get_child_count()
	Global.nut_removed.connect(nut_removed)
	$Wheel.fix_or_not.connect(show_fixable)
	Global.one_nut_reattached.connect(nut_attached)

func nut_attached():
	moved_nut += 1
	if moved_nut == nut_amount:
		print("ALL NUT ATTACHED")
		Global.tyre_game_finished.emit()

func nut_removed():
	moved_nut += 1
	if moved_nut == nut_amount:
		$Wheel.freeze = false
		$Wheel.activate()
		$Wheel.apply_impulse(Vector2(randf_range(-50, 50), -100))
		
func _on_world_side_border_body_entered(body: Node2D) -> void:
	if body is Wheel:
		body.hide()
		print("wheel disappeared")
		
		# 1. Create a physical transform for your target point
		var target_transform = Transform2D.IDENTITY.translated($TyreSpawnPoint.global_position)
		
		# 2. Tell the Physics Server directly to teleport the body's transform
		PhysicsServer2D.body_set_state(body.get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, target_transform)
		
		# 3. Tell the Physics Server directly to assign its new moving velocity (-500 or your choice)
		PhysicsServer2D.body_set_state(body.get_rid(), PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, Vector2(-500, 0))
		
		body.show()	
		body.WheelPng.frame = 1
		body.broken = false
		
func show_fixable(b:bool):
	if b == true:
		$SpanarButton.animate_appear()
	else:
		$SpanarButton.hide()

func _on_spanar_button_button_up() -> void:
	$SpanarButton.hide()
	wheel.attach()
	for i in all_nut_hole:
		var z = i as nuthole
		z.active = true
	moved_nut = 0
