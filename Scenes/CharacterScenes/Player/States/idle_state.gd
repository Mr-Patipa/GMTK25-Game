extends State

@export var Walk : State
@export var Airborne : State
@export var Dash : State
@export var JumpSFX : AudioStreamPlayer

#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass


func stateEnter() -> void: ## Runs whenever the state is changed into.
	if Parent is Player:
		Parent.velocity = Vector3.ZERO
		Parent.Dashed = false


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	if Parent is Player:
		Parent.move_and_slide()
		Parent.Camera.position = lerp(Parent.Camera.position, Parent.position + Vector3(0, Parent.CameraHeight, Parent.CameraOffset), Parent.CameraSpeed / 100)
		var Direction : Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
		
		if Direction != Vector2.ZERO:
			Parent.FacingDirection = Direction
			Parent.Direction = Direction
			return Walk
		
		if not Parent.is_on_floor():
			Parent.IsKayote = true
			Parent.KayoteTimer.set_wait_time(Parent.KayoteTime)
			Parent.KayoteTimer.start()
			return Airborne


func handleInputs(_event : InputEvent): ## unhandled_input()
	if Parent is Player:
		if _event.is_action_pressed("Jump"):
			JumpSFX.play()
			JumpSFX.seek(0.2)
			Parent.velocity.y = Parent.JumpHieght
			Parent.PreviousHeight = Parent.position.y
			return Airborne
		
		if _event.is_action_pressed("Dash"):
			return Dash
#endregion
