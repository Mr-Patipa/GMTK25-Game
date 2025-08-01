extends Node

@export var BulletScene: PackedScene

func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(on_create_bullet)

func on_create_bullet(StartPosition: Vector3, Direction: Vector3, Speed: float) -> void:
	var NewBullet: Bullet = BulletScene.instantiate()
	NewBullet.name = "Bullet@"
	
	call_deferred("add_child", NewBullet, true)
	
	NewBullet.call_deferred("setup", StartPosition, Direction, Speed)

	
	
