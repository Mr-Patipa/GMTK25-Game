extends State

@onready var DamageCooldownTimer: Timer = $DamageCooldownTimer

@export var Chasing: State

var _CanAttack: bool = true

#region Main Component of the State Class
func dependencyInjected() -> void: ## _ready() for states.
	pass

func stateEnter() -> void: ## Runs whenever the state is changed into.
	DamageCooldownTimer.wait_time = Parent.DamageComponentNode.AttackSpeed
	DamageCooldownTimer.start()


func stateExit() -> void: ## Runs when the state is changed out of.
	pass


func stepped(_delta : float): ## process()
	return null


func renderStepped(_delta : float): ## physics_process()
	
	if (Chasing != null) and (not Parent.canSeePlayer(Parent.AttackRange)):
		return Chasing
	
	if Parent.DamageComponentNode.IsRangeAttack == false:
		dealDamage(Parent.PlayerRef)
	else:
		var ShootPosistion: Vector3 = Parent.global_position
		var ShootDirection: Vector3 = Parent.global_position.direction_to(Parent.PlayerRef.global_position)
	
		shoot(ShootPosistion, ShootDirection)
		
	return null
		
		
func handleInputs(_event : InputEvent): ## unhandled_input()
	return null
#endregion

func dealDamage(PlayerRef: Player) -> void:
	if _CanAttack:
		Parent.PlayerRef.takeDamage(Parent.DamageComponentNode.AttackDamage)
		resetTimer()

func shoot(ShootPosition: Vector3, Direction: Vector3) -> void:
	if _CanAttack:
		SignalHub.emit_on_create_bullet(
			ShootPosition, Direction,
			Parent.DamageComponentNode.BulletSpeed, Parent.DamageComponentNode.AttackDamage
		)
		resetTimer()
	
func resetTimer() -> void:
	_CanAttack = false
	DamageCooldownTimer.start()

func _on_damage_cooldown_timer_timeout() -> void:
	_CanAttack = true
