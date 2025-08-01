extends State

@export var Chasing: State 

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
	if Parent.NavigationAgent.is_navigation_finished(): 
		if Parent.Waypoints.is_empty():
			return
	
		Parent.NavigationAgent.target_position = Parent.Waypoints[Parent.CurrentWaypoint]
		Parent.CurrentWaypoint = (Parent.CurrentWaypoint + 1) % Parent.Waypoints.size()
	
	print("[at]")
	Parent.update_movement()
	Parent.move_and_slide()
	
	if Parent.can_see_player():
		return Chasing
		
func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
			
#endregion
