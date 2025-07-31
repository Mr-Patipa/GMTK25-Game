extends Interactable

@export var MaxAngle : float = 90
@export var MinAngle : float = 0
@export var Duration : float = 0.5
@export var Hinge : Marker3D

var IsOpen : bool = false
var TweenDoor : Tween


func activate(_player : Player) -> void:
	if TweenDoor:
		TweenDoor.kill()
	
	TweenDoor = get_tree().create_tween()
	TweenDoor.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	
	if not IsOpen:
		TweenDoor.tween_property(Hinge, "rotation_degrees", Vector3(0, -MaxAngle, 0), Duration)
	
	else:
		TweenDoor.tween_property(Hinge, "rotation_degrees", Vector3(0, MinAngle, 0), Duration)
	
	TweenDoor.play()
	IsOpen = not IsOpen
