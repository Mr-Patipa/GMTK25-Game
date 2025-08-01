extends State

@export var DashForce : float = 20
@export var Decceleration : float = 20


@export var Airborne : State
var Debounce : bool
var Dashed : bool


#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass


func stateEnter() -> void: ## Runs whenever the state is changed into.
	if Parent is Player and not Dashed:
		Dashed = true
		Parent.velocity.y = 0

		Parent.velocity.x = Parent.FacingDirection.x * DashForce
		Parent.velocity.z = Parent.FacingDirection.y * DashForce


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.move_and_slide()
		var LocalHeight : Vector3 = Vector3(Parent.position.x, Parent.CameraHeight + + Parent.PreviousHeight, Parent.position.z + Parent.CameraOffset)
		Parent.Camera.position = lerp(Parent.Camera.position, LocalHeight, Parent.CameraSpeed / 100)
		Parent.velocity = Parent.velocity.move_toward(Vector3.ZERO, _delta * Decceleration)
	
		if Parent.velocity == Vector3.ZERO:
			return Airborne
		
		if Parent.is_on_floor():
			Dashed = false

func handleInputs(_event : InputEvent): ## unhandled_input()
	if Parent is Player:
		if _event.is_action_pressed("Jump"):
			if Parent.is_on_floor():
				Parent.velocity.y = Parent.JumpHieght
				return Airborne
			
			else:
				return Airborne
#endregion
