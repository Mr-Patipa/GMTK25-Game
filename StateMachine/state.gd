extends Node
class_name State

@warning_ignore("unused_signal")
signal state_changed(NextState : State)

var Parent : Node
var Machine : StateMachine ## The state machine that will be controling this state.



#region Main COmponent of the State Class
func Dependency_Injected() -> void: ## _ready() for states.
	pass


func State_Enter() -> void: ## Runs whenever the state is changed into.
	pass


func State_Exit() -> void: ## Runs when the state is changed out of.
	pass


func Stepped(_delta : float): ## process()
	return null


func Render_Stepped(_delta : float): ## physics_process()
	return null


func Handle_Inputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion
