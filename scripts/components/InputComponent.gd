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
@export var max_speed: float = 4.0
@export var horizontal_acceleration: float = 5.0
@export var horizontal_braking_speed: float = 7.5
@export var jump_velocity: float = 3


func _ready():
	Input.set_use_accumulated_input(false)


func _physics_process(delta: float) -> void:
	#process lateral movement, need to transform to basis
	var input_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var localized_input := Character.transform.basis * Vector3(input_vector.x, 0, input_vector.y)
	# we want to maintain momentum in all directions and just redirect it
	# apply the acceleration to the movement before applying to the vector
	var current_speed = Character.velocity.length() + (delta * horizontal_acceleration)

	#if no movement vector, we apply braking force to approach no velocity
	if localized_input == Vector3(0, 0, 0):
		#movement = Vector3(-Character.velocity.x, 0, -Character.velocity.z)
		Character.velocity.x = clamp(-Character.velocity.x * horizontal_braking_speed * delta, -max_speed, max_speed)
		Character.velocity.z = clamp(-Character.velocity.z * horizontal_braking_speed * delta, -max_speed, max_speed)
	else: #if input, we apply our updated magnitude to the new vector
		Character.velocity.x = clamp(localized_input.x * current_speed, -max_speed, max_speed)
		Character.velocity.z = clamp(localized_input.z * current_speed, -max_speed, max_speed)
		
	if Input.is_action_pressed("jump") and Character.is_on_floor():
		Character.velocity.y = jump_velocity
	#gravity if necessary
	elif not Character.is_on_floor():
		Character.velocity.y = clamp(Character.velocity.y - (7.5 * delta), -100, 100)
	


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
