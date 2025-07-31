extends Node
class_name StateMachine

signal is_activated
signal dependency_injected


@export var Active : bool :
	set(Value):
		Active = Value
		is_activated.emit(Active)
		
		if Active:
			CurrentState = InitialState

@export var Parent : Node ## Add anything under the Node class.
@export var InitialState : State ## A state that the machine can start off with.
@export var Debug : bool = false ## Debug state interactions

var CurrentState : State
var NewState : State
var States : Array[State]

#region Preparation
func _ready() -> void:
	dependencyInjection()
	CurrentState = InitialState
	CurrentState.stateEnter()
	
	for state in States:
		dependency_injected.connect(state.dependencyInjected)
		dependency_injected.emit()


func dependencyInjection() -> void: ## Inject information to the states
	for state in get_children():
		if state is State:
			States.append(state)
			
			state.Parent = Parent
			state.Machine = self
			
			state.state_changed.connect(changeState)
			
			if Debug:
				print("Injection Completed")

#endregion

#region Feed States
func changeState(newState : State) -> void: ## Used to Enter a new state. Can be called through a signal from the states or, when any of the functions return 
	if Active:
		if newState and newState != CurrentState:
			if Debug:
				print(CurrentState.name, " -> " ,NewState.name)
			
			CurrentState.stateExit()
			CurrentState = newState
			CurrentState.stateEnter()


func _process(delta: float) -> void: ## Feeds Stepped()
	if Active:
		NewState = CurrentState.stepped(delta)
		changeState(NewState)


func _physics_process(delta: float) -> void: ## Feeds Render_Stepped()
	if Active:
		NewState = CurrentState.renderStepped(delta)
		changeState(NewState)


func _unhandled_input(event: InputEvent) -> void: ## Feeds Handle_Inputs()
	if Active:
		NewState = CurrentState.handleInputs(event)
		changeState(NewState)

#endregion
