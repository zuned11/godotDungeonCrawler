class_name HurtBox extends Area3D

@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not health_component:
		health_component = get_parent().get_node("HealthComponent")
	assert(health_component)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
