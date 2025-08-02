extends Node3D

@export var Body3D : AnimatableBody3D
@export var M1 : Marker3D
@export var M2 : Marker3D
var MoveTween : Tween
var Ended : bool = false

func _ready() -> void:
	startTweening()

func startTweening() -> void:
	if MoveTween:
		MoveTween.kill()
	
	MoveTween = get_tree().create_tween()
	MoveTween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	if not Ended:
		Ended = true
		MoveTween.tween_property(Body3D, "global_position", M2.global_position, 1)
		
	else:
		Ended = false
		MoveTween.tween_property(Body3D, "global_position", M1.global_position, 1)
	
	MoveTween.play()
	MoveTween.finished.connect(startTweening)
	
	
