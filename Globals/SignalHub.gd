extends Node

signal on_create_bullet(
	StartPosition: Vector3, Direction: Vector3, 
	Speed: float, Damage: int
)

func emit_on_create_bullet(StartPosition: Vector3, Direction: Vector3, Speed: float, Damage: int) -> void:
	on_create_bullet.emit(StartPosition, Direction, Speed, Damage)
	
