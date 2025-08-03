extends State

@export var AnimTree : AnimationTree

#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass


func stateEnter() -> void: ## Runs whenever the state is changed into.
	AnimTree["parameters/conditions/IsIdling"] = true
	AnimTree["parameters/Idle/blend_position"] = Parent.FacingDirection.y


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.move_and_slide()
		
		if not Parent.is_on_floor():
			Parent.velocity = Parent.velocity.move_toward(Vector3(0, -Parent.Gravity, 0), _delta * Parent.Gravity)
		
		Parent.velocity.x = 0
		Parent.velocity.z = 0

func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion
