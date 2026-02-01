class_name InputComponent extends Node


#nodes
@export_group("Nodes")

#character node
@export var Character: CharacterBody3D

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

#movement speeds
@export_group("Movement settings")

@export_subgroup("Horizontal movement")
@export var max_speed: float = 5.0
@export var jump_velocity: float = 5


func _ready():
	Input.set_use_accumulated_input(false)


func _physics_process(_delta: float) -> void:
	#process lateral movement, need to transform to basis
	var movement_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement = Character.transform.basis * Vector3(movement_vector.x, 0, movement_vector.y)
	
	Character.velocity.x = movement.x * max_speed
	Character.velocity.z = movement.z * max_speed
	
	if Input.is_action_pressed("jump") and Character.is_on_floor():
		Character.velocity.y = jump_velocity
	
	print(Character.velocity)


func _unhandled_input(event: InputEvent) -> void:
	#if the mouse isn't captured, escape quits game
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		if event is InputEventKey:
			if event.is_action_pressed("ui_cancel"):
				get_tree().quit()
		#if mouse isn't captured and we click, recapture
		if event is InputEventMouseButton:
			if event.button_index == 1:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				
		return
		
	# if the mouse isn't captured and we hit esc again, exit game
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	#if the event is mouse movement, we aimlook
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
		
	Character.rotate_object_local(Vector3.DOWN, deg_to_rad(amount))
	Character.orthonormalize()
	
	
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
