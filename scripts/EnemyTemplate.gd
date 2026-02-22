extends CharacterBody3D

@onready var health_component = get_node("HealthComponent")
#@export var defense : DefenseComponent


func _ready() -> void:
	if is_instance_of(health_component, HealthComponent):
		print("found health component")
		#health_component.take_damage.connect("take_damage")
		health_component.entity_died.connect(die)


func _process(_delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	move_and_slide()


func die() -> void:
	queue_free()

func take_damage(damage: float) -> void:
	print("going to take " + str(damage) + "dmg")
	if not is_instance_of(health_component, HealthComponent):
		print("can't be damaged")
		return #exit if we can't damage
	health_component.take_damage(damage)
	print(health_component.current_health)
