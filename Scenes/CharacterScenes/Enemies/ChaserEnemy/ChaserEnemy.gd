extends CharacterBody3D
class_name ChaserEnemy

@onready var DebugLabel: Label3D = $DebugLabel
@onready var NavigationAgent: NavigationAgent3D = $NavigationAgent
@onready var LifeTimer: Timer = $LifeTimer

@onready var DamageComponentNode: DamageComponent = $DamageComponent
@onready var HealthComponentNode: Node = $HealthComponent
@onready var SpeedComponentNode: Node = $SpeedComponent

@export var LifeTime : float = 30.0

@export var MaxHealth: float = 100.0
@export var Speed: float = 10.0

@export_group("Object References")
@export var PlayerRef : Player

@export_group("Combat")
@export var AttackDamage: int = 10.0
@export var AttackSpeed: float = 2.0
@export var DetectionRange: float = 10.0
@export var AttackRange: float = 2.0

func _ready() -> void:
	if !PlayerRef:
		queue_free()
		
	LifeTimer.start(LifeTime)
	
	HealthComponentNode.MaxHealth = MaxHealth
	SpeedComponentNode.Speed = Speed
	
	DamageComponentNode.AttackDamage = AttackDamage
	DamageComponentNode.AttackSpeed = AttackSpeed
	DamageComponentNode.DetectionRange = DetectionRange
	DamageComponentNode.AttackRange = AttackRange
	

	
func _process(_delta: float) -> void:
	DebugLabel.text = str(round(LifeTimer.time_left))
	
func _on_life_timer_timeout() -> void:
	queue_free()
	
func updateMovement() -> void:
	if NavigationAgent.is_navigation_finished(): 
		return
	else:
		var NextPathPosition: Vector3 = NavigationAgent.get_next_path_position()
		var LocalDestination = NextPathPosition - global_position
		var Direction = LocalDestination.normalized()
	
		velocity = Direction * Speed
		
func canSeePlayer(ViewRange: float) -> bool:
	var ParentPos: Vector3 = global_position
	var PlayerPos: Vector3 = PlayerRef.global_position
	
	var Distance = ParentPos.distance_to(PlayerPos)
	
	return Distance <= ViewRange
