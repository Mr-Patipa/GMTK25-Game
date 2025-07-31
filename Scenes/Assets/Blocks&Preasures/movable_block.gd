extends Node3D
class_name MovableBlock

@export var MinLimit : float = -10
@export var MaxLimit : float = 100
@export var Block : RigidBody3D
@export var SpawnPos : Marker3D


func _physics_process(_delta: float) -> void:
	checkYIndex()

	if Block.linear_velocity.y == 0:
		Block.linear_damp = 20
	else:
		Block.linear_damp = 2
		


func checkYIndex() -> void:
	if Block.position.y < MinLimit:
		Block.position.y = 5
	
	elif Block.position.y > MaxLimit:
		Block.position.y = 5
