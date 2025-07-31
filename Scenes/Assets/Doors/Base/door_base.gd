extends Node3D
class_name Door

@export var MaxAngle : float = 90
@export var MinAngle : float = 0
@export var Duration : float = 0.5

@export var RequireItem : bool = false
@export var Billboard : Interactable
@export var Hinge : Marker3D

var IsOpen : bool = false
var TweenDoor : Tween
var Debounce : bool = false


func _ready() -> void:
	Billboard.is_activated.connect(checkStatus)


func checkStatus() -> void:
	if not Debounce:
		if TweenDoor:
			TweenDoor.kill()
		
		TweenDoor = get_tree().create_tween()
		TweenDoor.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
		
		if not IsOpen:
			TweenDoor.tween_property(Hinge, "rotation_degrees", Vector3(0, -MaxAngle, 0), Duration)
		
		else:
			TweenDoor.tween_property(Hinge, "rotation_degrees", Vector3(0, MinAngle, 0), Duration)
		
		TweenDoor.play()
		TweenDoor.finished.connect(func() -> void: Debounce = false)
		Debounce = true
		IsOpen = not IsOpen
