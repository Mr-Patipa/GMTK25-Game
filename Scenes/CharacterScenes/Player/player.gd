extends CharacterBody3D
class_name Player

@export var WalkSpeed : float = 100
@export var JumpHieght : float = 400
@export var Gravity : float = 981
@export var Health : float = 100
@export var FacingDirection : Vector2
@export var Camera : Camera3D


#func _physics_process(delta: float) -> void:
	#print(velocity)
