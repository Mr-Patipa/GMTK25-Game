extends State

@export var Searching: State

#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass

func stateEnter() -> void: ## Runs whenever the state is changed into.
	pass


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(delta : float): ## physics_process()
	Parent.NavigationAgent.target_position = Parent.PlayerRef.global_position
	Parent.update_movement()
	

	if not Parent.can_see_player():
		return Searching
		
	Parent.move_and_slide()
	

func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion


	
