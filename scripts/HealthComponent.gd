class_name HealthComponent extends Node

signal entity_died
signal health_changed(new_health: float)
signal max_health_changed(new_max_health: float)

@export var maxHealth: float

var currentHealth: float

func _ready() -> void:
	max_health_changed.emit(maxHealth)
	_initialize_health(maxHealth)


func _initialize_health(newMaxHealth: float, healthToSet: float = -1) -> void:
	assert(newMaxHealth > 0)
	maxHealth = newMaxHealth
	assert(healthToSet > 0)
	currentHealth = healthToSet


func take_damage(dmg_to_take: float) -> void:
	currentHealth = clamp(currentHealth - dmg_to_take, 0, maxHealth)
	if currentHealth <= 0.0:
		entity_died.emit()
	else:
		health_changed.emit(currentHealth)
		

func heal_damage(dmg_to_heal: float) -> void:
	currentHealth = clamp(currentHealth + dmg_to_heal, 0, maxHealth)
	health_changed.emit(currentHealth)
