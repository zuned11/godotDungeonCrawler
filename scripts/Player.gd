class_name Player extends CharacterBody3D

@onready var input_component: InputComponent = %InputComponent

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(_delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	print('starting phsyics')
	if not is_on_floor():
		velocity.y -= default_gravity * delta
	print(self.velocity)
	move_and_slide()
