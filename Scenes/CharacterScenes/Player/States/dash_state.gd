extends State

@export var DashForce : float = 20
@export var Decceleration : float = 20
@export var Airborne : State
@export var JumpSFX : AudioStreamPlayer
@export var AnimTree : AnimationTree


var Debounce : bool



#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass


func stateEnter() -> void: ## Runs whenever the state is changed into.
	if Parent is Player and not Parent.Dashed:
		Parent.Dashed = true
		Parent.velocity.y = 0

		Parent.velocity.x = Parent.FacingDirection.x * DashForce
		Parent.velocity.z = Parent.FacingDirection.y * DashForce
		AnimTree["parameters/conditions/IsIdling"] = true
		AnimTree["parameters/Idle/blend_position"] = Parent.FacingDirection.y


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.move_and_slide()
		
		Parent.Camera.position = lerp(Parent.Camera.position, Parent.position + Vector3(0, Parent.CameraHeight, Parent.CameraOffset), Parent.CameraSpeed / 100)
		Parent.velocity = Parent.velocity.move_toward(Vector3.ZERO, _delta * Decceleration)
	
		if Parent.velocity == Vector3.ZERO:
			return Airborne

func handleInputs(_event : InputEvent): ## unhandled_input()
	if Parent is Player:
		if _event.is_action_pressed("Jump"):
			if Parent.is_on_floor():
				JumpSFX.play()
				JumpSFX.seek(0.2)
				Parent.velocity.y = Parent.JumpHieght
				Parent.PreviousHeight = Parent.position.y
				return Airborne
			
			else:
				return Airborne
#endregion
