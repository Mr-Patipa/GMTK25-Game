extends State

@export var Damaging: State

func dependencyInjected() -> void: ## _ready() for states.
	pass

func stateEnter() -> void: ## Runs whenever the state is changed into.
	pass


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent.canSeePlayer(Parent.DetectionRange):
		return Damaging
		
	return null
	

func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion


	
