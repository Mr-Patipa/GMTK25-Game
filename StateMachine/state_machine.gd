extends Node
class_name StateMachine

signal is_active
signal dependency_injected


@export var Active : bool :
	set(Value):
		Active = Value
		is_active.emit(Active)
		
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
	Dependency_Injection()
	CurrentState = InitialState
	CurrentState.State_Enter()
	
	for state in States:
		dependency_injected.connect(state.Dependency_Injected)
		dependency_injected.emit()


func Dependency_Injection() -> void: ## Inject information to the states
	for state in get_children():
		if state is State:
			States.append(state)
			
			state.Parent = Parent
			state.Machine = self
			
			state.state_changed.connect(Change_State)
			
			if Debug:
				print("Injection Completed")

#endregion

#region Feed States
func Change_State(newState : State) -> void: ## Used to Enter a new state. Can be called through a signal from the states or, when any of the functions return 
	if Active:
		if newState and newState != CurrentState:
			if Debug:
				print(CurrentState.name, " -> " ,NewState.name)
			
			CurrentState.State_Exit()
			CurrentState = newState
			CurrentState.State_Enter()


func _process(delta: float) -> void: ## Feeds Stepped()
	if Active:
		NewState = CurrentState.Stepped(delta)
		Change_State(NewState)


func _physics_process(delta: float) -> void: ## Feeds Render_Stepped()
	if Active:
		NewState = CurrentState.Render_Stepped(delta)
		Change_State(NewState)


func _unhandled_input(event: InputEvent) -> void: ## Feeds Handle_Inputs()
	if Active:
		NewState = CurrentState.Handle_Inputs(event)
		Change_State(NewState)

#endregion
