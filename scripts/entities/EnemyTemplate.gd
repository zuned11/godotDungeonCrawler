extends CharacterBody3D

#@export var defense : DefenseComponent

@onready var health_component = get_node("HealthComponent")
@onready var nav_agent = $NavigationAgent3D

@export var player: Node3D = null
@export var player_sightline: RayCast3D

const SPEED := 5.0
const GRAVITY := 9.8

var player_in_range: bool = false
var player_in_sight: bool = false
var player_last_position: Vector3

func _ready() -> void:
	if is_instance_of(health_component, HealthComponent):
		print("found health component")
		#health_component.take_damage.connect("take_damage")
		health_component.entity_died.connect(die)
	player = %CharacterController



func _process(_delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	# identify if our target is in range
	if position.direction_to(player_last_position).dot(-player.global_transform.basis.z) > 0:
		print("Can see the player!")
		player_last_position = player.global_position
	nav_agent.set_target_position(player_last_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_position).normalized() * SPEED
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
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
