extends State

@export var Idle : State
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
		Parent.move_and_slide()
		var LocalHeight : Vector3 = Vector3(Parent.position.x, Parent.CameraHeight + Parent.PreviousHeight, Parent.position.z + Parent.CameraOffset)
		Parent.Camera.position = lerp(Parent.Camera.position, LocalHeight, Parent.CameraSpeed / 100)
		
		if Parent.is_on_floor():
			return Idle
		
		else:
			var Direction : Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
		
			Parent.velocity.x = Direction.x * Parent.WalkSpeed
			Parent.velocity.z = Direction.y * Parent.WalkSpeed
			Parent.velocity = Parent.velocity.move_toward(Vector3(0, -Parent.Gravity, 0), _delta * Parent.Gravity)


func handleInputs(_event : InputEvent): ## unhandled_input()
	if Parent is Player:
		if _event.is_action_pressed("Dash"):
			return Dash
#endregion
