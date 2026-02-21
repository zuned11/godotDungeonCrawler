class_name WeaponComponent 
extends Node

@export_category("Weapon Stats")
@export var attack_damage: float = 25.0
@export var attack_range: float = 5.0 #not used yet

@export var weapon_area: Area3D
@export var animation_player: AnimationPlayer

#@onready var swooshSound = $SwooshSound

var attack_on_cooldown: bool = true

func _ready() -> void:
	animation_player.play("equip")

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept") and Input.MOUSE_MODE_CAPTURED:
		#animation_player.play("attack")


func _process(_delta: float) -> void:
	if !animation_player.is_playing():
		attack_on_cooldown = false
		
	if Input.is_action_pressed("attack") and not attack_on_cooldown and Input.MOUSE_MODE_CAPTURED:
		print("attacking")
		animation_player.play("attack")
		attack_on_cooldown = true
		var enemies_in_range: Array[Node3D] = weapon_area.get_overlapping_bodies()
		if !enemies_in_range.is_empty():
			for e in enemies_in_range:
				pass



func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "equip":
		attack_on_cooldown = false
	elif anim_name == "attack":
		attack_on_cooldown = false
		animation_player.play("RESET")

#
#func _on_hitbox_body_entered(body: Node3D) -> void:
	#if body.is_in_group("enemy") and not enemies_in_range.has(body):
		#enemies_in_range.append(body)
		#
#
#func _on_hitbox_body_exited(body: Node3D) -> void:
	#if enemies_in_range.has(body):
		#enemies_in_range.erase(body)
