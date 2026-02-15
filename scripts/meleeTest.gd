extends Node3D

@export_category("Weapon Stats")
@export var damage: float = 25.0

@onready var anim = $AnimationPlayer
@onready var swooshSound = $SwooshSound

var can_attack = false
var enemies_in_range = []


func _ready() -> void:
	anim.play("equip")


func _process(_delta: float) -> void:
	if !anim.is_playing():
		can_attack = true
	
	print("processing weapon")
	if Input.is_action_pressed("attack") and can_attack and not anim.is_playing():
		print("attacking")
		anim.play("attack")
		swooshSound.play()
		can_attack = false
		if !enemies_in_range.is_empty():
			for e in enemies_in_range:
				pass

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not enemies_in_range.has(body):
		enemies_in_range.append(body)
		

func _on_hitbox_body_exited(body: Node3D) -> void:
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)
		

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "equip":
		can_attack = true
		visible = true
	elif anim_name == "attack":
		can_attack = true
		anim.play("RESET")
