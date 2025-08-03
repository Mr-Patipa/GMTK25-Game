extends State

@export var Idle : State
@export var Airborne : State
@export var Dash : State
@export var JumpSFX : AudioStreamPlayer
@export var WalkSFX : AudioStreamPlayer
@export var AnimTree : AnimationTree


#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass


func stateEnter() -> void: ## Runs whenever the state is changed into.
	WalkSFX.play()
	AnimTree["parameters/conditions/IsIdling"] = false
	AnimTree["parameters/conditions/IsWalking"] = true

func stateExit() -> void: ## Runs when the state is changed out of.
	WalkSFX.stop()
	AnimTree["parameters/conditions/IsIdling"] = true
	AnimTree["parameters/conditions/IsWalking"] = false


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.Camera.position = lerp(Parent.Camera.position, Parent.position + Vector3(0, Parent.CameraHeight, Parent.CameraOffset), Parent.CameraSpeed / 100)
		if not Parent.Inversed:
			Parent.Direction = Input.get_vector("Left", "Right", "Up", "Down")
		
		else:
			Parent.Direction = -Input.get_vector("Left", "Right", "Up", "Down")
		
		Parent.velocity.x = Parent.Direction.x * (Parent.WalkSpeed + Parent.SpeedChange)
		Parent.velocity.z = Parent.Direction.y * (Parent.WalkSpeed + Parent.SpeedChange)
		
		Parent.move_and_slide()
		
		if Parent.Direction == Vector2.ZERO:
			return Idle
		else:
			Parent.FacingDirection = Parent.Direction
		
		AnimTree["parameters/Walk/blend_position"] = Parent.FacingDirection
		
		if not Parent.is_on_floor():
			Parent.IsKayote = true
			Parent.KayoteTimer.set_wait_time(Parent.KayoteTime)
			Parent.KayoteTimer.start()
			return Airborne


func handleInputs(_event : InputEvent): ## unhandled_input()
	if Parent is Player:
		if _event.is_action_pressed("Jump"):
			JumpSFX.play()
			JumpSFX.seek(0.2)
			Parent.velocity.y = Parent.JumpHieght
			Parent.PreviousHeight = Parent.position.y
			return Airborne
		
		if _event.is_action_pressed("Dash"):
			return Dash
#endregion
