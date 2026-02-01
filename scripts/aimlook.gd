extends Node


#nodes
@export_group("Nodes")

#character node
@export var character: CharacterBody3D

#head node
@export var head: Node3D

#Settings
@export_group("Settings")

#mouse sense
@export_group("Mouse settings")
@export_range(1, 100, 1) var mouse_sensitivity: int = 50

@export_subgroup("Clamp settings")
#max and min pitch for head angle
@export var max_pitch: float = 89
@export var min_pitch: float = -89


func _ready():
	Input.set_use_accumulated_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		if event is InputEventKey:
			if event.is_action_pressed("ui_cancel"):
				get_tree().quit()
				
		if event is InputEventMouseButton:
			if event.button_index == 1:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				
		return
		
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if event is InputEventMouseMotion:
		aim_look(event)

func aim_look(event: InputEventMouseMotion) -> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.001
	
	motion *= mouse_sensitivity
	motion *= degrees_per_unit
	add_yaw(motion.x)
	add_pitch(motion.y)

#rotate the character aroudn the local Y axis by given amount (in degrees)
func add_yaw(amount)-> void:
	if is_zero_approx(amount):
		return
		
	character.rotate_object_local(Vector3.DOWN, deg_to_rad(amount))
	character.orthonormalize()
	
#rotate the character around the local X axis by given amount (in degrees)
func add_pitch(amount)->void:
	if is_zero_approx(amount):
		return
		
	head.rotate_object_local(Vector3.LEFT, deg_to_rad(amount))
	head.orthonormalize()
	
func clamp_pitch()->void:
	if head.rotation.x > deg_to_rad(min_pitch) and head.rotation.x < deg_to_rad(max_pitch):
		return
		
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
