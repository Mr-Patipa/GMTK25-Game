extends Node
class_name State

@warning_ignore("unused_signal")
signal state_changed(NextState : State)

var Parent : Node
var Machine : StateMachine ## The state machine that will be controling this state.



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
	return null


func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion
