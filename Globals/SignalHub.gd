extends Node

signal on_create_bullet(
	StartPosition: Vector3, Direction: Vector3, 
	Speed: float,
)

func emit_on_create_bullet(StartPosition: Vector3, Direction: Vector3, Speed: float) -> void:
	on_create_bullet.emit(StartPosition, Direction, Speed)
	
