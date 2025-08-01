extends CharacterBody3D
class_name Player

@export var Health : float = 100
@export var Machine : StateMachine
@export var Death : State

@export_category("Movement Related")
@export var WalkSpeed : float = 100
@export var JumpHieght : float = 400
@export var Gravity : float = 981

@export_category("Dash Related")
@export var Mass : float = 80
@export var Force : float = 5
@export var FacingDirection : Vector2

@export_category("Camera Related")
@export var CameraSpeed : float = 15
@export var CameraHeight : float = 20
@export var CameraOffset : float = 35
@export var InitialStrength : float = 1
@export var StrengthIncrease : float = 1.5
@export var OffsetTime : float = 0.02
@export var InitialFOV : float = 75
@export var FinalFOV : float = 20
@export var Camera : Camera3D
@export var CShakeOffsetTimer : Timer
var PreviousHeight : float = 0
var CurrentStrength : float = 0

var TweenFOV : Tween
var Safe : bool = false
var CurrentTime : int


func _ready() -> void:
	CShakeOffsetTimer.timeout.connect(pickNewLocation)
	GameManager.time_change_notified.connect(strengthMultiplier)
	GameManager.player_readyed.connect(func() -> void:
		Safe = false
		if CurrentTime <= 10:
			CurrentStrength = InitialStrength
			pickNewLocation()
			startTweeningFOV()
	)
	GameManager.player_saved.connect(func() -> void:
		Safe = true
		if TweenFOV:
			TweenFOV.kill()
	)
	GameManager.not_much_time_left.connect(func() -> void:
		CurrentStrength = InitialStrength
		pickNewLocation()
		startTweeningFOV()
	)
	
	GameManager.time_ran_out.connect(func() -> void:
		Machine.changeState(Death)
	)

func _physics_process(_delta: float) -> void:
	pushBlocks()
	


func pushBlocks() -> void:
	for node in get_slide_collision_count():
		var block = get_slide_collision(node)
		if block.get_collider() is RigidBody3D:
			var Direction = -block.get_normal()
			var Resistence = self.velocity.dot(Direction) - block.get_collider().linear_velocity.dot(Direction)
			Resistence = max(0, Resistence)
			var MassRatio = min(1, Mass / block.get_collider().mass)
			Direction.y = 0
			
			var PushForce = MassRatio * Force
			block.get_collider().apply_impulse(Direction * Resistence * PushForce, block.get_position() - block.get_collider().global_position)


func strengthMultiplier(time : int) -> void:
	CurrentTime = time
	
	if time < 10:
		CurrentStrength += StrengthIncrease
	
	if time > 10 or time == 0:
		itsOkay()
		CurrentStrength = 0
		CShakeOffsetTimer.stop()


func pickNewLocation() -> void:
	
	if Safe == false:
		randomize()
		var RandomLocation : Vector3 = Vector3(
			randf_range(-CurrentStrength / 10, CurrentStrength / 10),
			randf_range(-CurrentStrength / 10, CurrentStrength / 10),
			randf_range(-CurrentStrength / 10, CurrentStrength / 10)
		)
		
		Camera.global_position += RandomLocation
		CShakeOffsetTimer.set_wait_time(OffsetTime)
		CShakeOffsetTimer.start()


func startTweeningFOV() -> void:
	if TweenFOV:
		TweenFOV.kill()
	
	TweenFOV = get_tree().create_tween()
	TweenFOV.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	TweenFOV.tween_property(Camera, "fov", FinalFOV, 10)


func itsOkay() -> void:
	if TweenFOV:
		TweenFOV.kill()
	
	TweenFOV = get_tree().create_tween()
	TweenFOV.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	TweenFOV.tween_property(Camera, "fov", InitialFOV, 1)
	
func takeDamage(TakenDamage: int) -> void:
	Health -= TakenDamage
