extends State

@export var Searching: State
@export var AttackComponentNode: AttackComponent

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
	
	if not Parent.can_see_player(Parent.DetectionRange):
		return Searching 
		
	var ShootPosistion: Vector3 = Parent.global_position
	var ShootDirection: Vector3 = Parent.global_position.direction_to(Parent.PlayerRef.global_position)
	
	AttackComponentNode.shoot(ShootPosistion, ShootDirection)
	
	return null
		
		
func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion
