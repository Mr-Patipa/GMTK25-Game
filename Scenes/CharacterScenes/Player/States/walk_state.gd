extends State

@export var Idle : State
@export var Airborne : State
@export var Dash : State

#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass


func stateEnter() -> void: ## Runs whenever the state is changed into.
	pass


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.Camera.position = lerp(Parent.Camera.position, Parent.position + Vector3(0, Parent.CameraHeight, Parent.CameraOffset), Parent.CameraSpeed / 100)
		var Direction : Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
		
		Parent.velocity.x = Direction.x * Parent.WalkSpeed
		Parent.velocity.z = Direction.y * Parent.WalkSpeed
		
		Parent.move_and_slide()
		
		if Direction == Vector2.ZERO:
			return Idle
		else:
			Parent.FacingDirection = Direction
		
		if not Parent.is_on_floor():
			return Airborne


func handleInputs(_event : InputEvent): ## unhandled_input()
	if Parent is Player:
		if _event.is_action_pressed("Jump"):
			Parent.velocity.y = Parent.JumpHieght
			Parent.PreviousHeight = Parent.position.y
			return Airborne
		
		if _event.is_action_pressed("Dash"):
			return Dash
#endregion
