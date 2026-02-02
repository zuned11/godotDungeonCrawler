class_name WeaponComponent extends Node

@export var weaponModel: Node3D

@onready var weapon: Area3D = $WeaponArea



#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept") and Input.MOUSE_MODE_CAPTURED:
		#weapon.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
