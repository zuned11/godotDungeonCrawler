class_name HealthComponent extends Node

signal entity_died
signal health_changed(new_health: float)
#signal max_health_changed(new_max_health: float)

@export var maxHealth: float

var current_health: float

func _ready() -> void:
	#max_health_changed.emit(maxHealth)
	_initialize_health(maxHealth)


func _initialize_health(new_max_health: float, health_to_set: float = -1) -> void:
	assert(new_max_health > 0)
	maxHealth = new_max_health
	health_to_set = new_max_health if health_to_set < 0 else health_to_set
	assert(health_to_set > 0)
	current_health = health_to_set


func take_damage(dmg_to_take: float) -> void:
	current_health = clamp(current_health - dmg_to_take, 0, maxHealth)
	if current_health <= 0.0:
		entity_died.emit()
	else:
		health_changed.emit(current_health)
		

func heal_damage(dmg_to_heal: float) -> void:
	current_health = clamp(current_health + dmg_to_heal, 0, maxHealth)
	health_changed.emit(current_health)
	
	
func _on_take_damage(damage: float) -> void:
	take_damage(damage)
