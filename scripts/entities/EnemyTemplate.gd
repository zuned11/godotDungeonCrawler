extends CharacterBody3D

#@export var defense : DefenseComponent

@onready var health_component = get_node("HealthComponent")
@onready var nav_agent = $NavigationAgent3D


var player = null

const SPEED := 5.0



func _ready() -> void:
	if is_instance_of(health_component, HealthComponent):
		print("found health component")
		#health_component.take_damage.connect("take_damage")
		health_component.entity_died.connect(die)




func _process(_delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	if not is_on_floor():
		velocity.y -= 9.8 * delta
#	nav_agent.set_target_position(player.global_position)
#	var next_nav_point = nav_agent.get_next_path_position()
#	velocity = (next_nav_point - global_position).normalized() * SPEED
	

func die() -> void:
	queue_free()

func take_damage(damage: float) -> void:
	print("going to take " + str(damage) + "dmg")
	if not is_instance_of(health_component, HealthComponent):
		print("can't be damaged")
		return #exit if we can't damage
	health_component.take_damage(damage)
	print(health_component.current_health)
