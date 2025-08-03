extends Area3D
class_name Collectable

@export var Parent : Node3D

func playerEntered(body : Node3D) -> void:
	if body is Player:
		body.ItemCount += 1
		Parent.call_deferred("queue_free")
