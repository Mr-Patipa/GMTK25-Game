extends Node3D
class_name PreasurePlates

@export var Target : Interactable
@export var Detector : Area3D


func _ready() -> void:
	Detector.body_entered.connect(func(body : Node3D) -> void:
		for group in body.get_groups():
			if group == "Block":
				Target.activate(null)
		)
	
	Detector.body_exited.connect(func(body : Node3D) -> void:
		for group in body.get_groups():
			if group == "Block":
				Target.activate(null)
		)
