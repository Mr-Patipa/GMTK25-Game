extends State


@export var Idle : State
@export var KnockForce : float = 5
@export var Decceleration : float = 10

func _ready() -> void:
	GameManager.player_collided.connect(func(body : Node3D) -> void:
		state_changed.emit(self)
	)


#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass

func stateEnter() -> void: ## Runs whenever the state is changed into.
	if Parent is Player:
		Parent.velocity.x = KnockForce * -Parent.FacingDirection.x
		Parent.velocity.z = KnockForce * -Parent.FacingDirection.y


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.move_and_slide()
		Parent.velocity = Parent.velocity.move_toward(Vector3.ZERO, _delta * Decceleration)
		Parent.Camera.position = lerp(Parent.Camera.position, Parent.position + Vector3(0, Parent.CameraHeight, Parent.CameraOffset), Parent.CameraSpeed / 100)
		
		if Parent.velocity == Vector3.ZERO:
			return Idle


func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion
