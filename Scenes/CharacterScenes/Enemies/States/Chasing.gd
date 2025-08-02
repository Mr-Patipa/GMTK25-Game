extends State

@export var Damaging: State
@export var Patrolling: State

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
	
	Parent.NavigationAgent.target_position = Parent.PlayerRef.global_position
	Parent.updateMovement()
	
	if (Patrolling != null) and (not Parent.canSeePlayer(Parent.DetectionRange)):
		return Patrolling
	
	if Parent.canSeePlayer(Parent.AttackRange):
		return Damaging
		
	Parent.move_and_slide()
	

func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion


	
