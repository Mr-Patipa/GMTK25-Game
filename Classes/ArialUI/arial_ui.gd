extends Node3D
class_name ArialUI

@export var SelfDestruct : bool = false
@export var Require : Interactable
@export var AreaDetector : Area3D
@export var Target : Interactable
@export var Screen : MeshInstance3D

var Clickable : bool = false
var player : Player

func _ready() -> void:
	AreaDetector.body_entered.connect(onBodyEntered)
	AreaDetector.body_exited.connect(onBodyExited)
	

func onBodyEntered(body: Node3D) -> void:
	if body is Player:
		Clickable = true
		Screen.visible = true
		player = body


func onBodyExited(body: Node3D) -> void:
	if body is Player:
		Clickable = false
		Screen.visible = false
		player = body

func _unhandled_input(event: InputEvent) -> void:
	if Clickable and event.is_action_pressed("Interact"):
		if Require != null:
			if Require.get_parent().get_parent() is Player:
				Target.activate(player)
				Require.call_deferred("queue_free")
				
				if SelfDestruct:
					self.call_deferred("queue_free")
		
		else:
			Target.activate(player)
				
			if SelfDestruct:
				self.call_deferred("queue_free")
