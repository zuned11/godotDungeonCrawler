class_name State
extends Node

signal state_exited(next_state_path: String, data: Dictionary)


func enter(previous_state_path: String, data := {}) -> void:
	pass


func exit() -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func phsyics_update(_delta: float) -> void:
	pass
