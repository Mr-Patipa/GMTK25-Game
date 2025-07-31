extends Node3D
class_name Interactable

signal is_activated

@export var AreaDetector : Area3D

var Clickable : bool = false

func _ready() -> void:
	AreaDetector.body_entered.connect(onBodyEntered)
	AreaDetector.body_exited.connect(onBodyExited)
	

func onBodyEntered(body: Node3D) -> void:
	if body is Player:
		Clickable = true

func onBodyExited(body: Node3D) -> void:
	if body is Player:
		Clickable = false

func _unhandled_input(event: InputEvent) -> void:
	if Clickable and event.is_action_pressed("Interact"):
		is_activated.emit()
