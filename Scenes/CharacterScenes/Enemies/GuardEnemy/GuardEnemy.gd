extends CharacterBody3D
class_name GuardEnemy

@onready var NavigationAgent: NavigationAgent3D = $NavigationAgent
@onready var DamageComponentNode: DamageComponent = $DamageComponent
@onready var HealthComponentNode: HealthComponent = $HealthComponent
@onready var SpeedComponentNode: SpeedComponent = $SpeedComponent

@export var MaxHealth: float = 100.0
@export var Speed: float = 10.0

@export_group("Object References")
@export var PlayerRef : Player
@export var PatrolPoints: NodePath

@export_group("Combat")
@export var AttackDamage: int = 10.0
@export var AttackSpeed: float = 2.0
@export var DetectionRange: float = 10.0
@export var AttackRange: float = 2.0

var Waypoints: Array[Vector3] = []
var CurrentWaypoint: int = 0

@onready var state_machine: StateMachine = $StateMachine
@onready var patrolling: Node = $StateMachine/Patrolling
@onready var chasing: Node = $StateMachine/Chasing

func _ready() -> void:
	if !PlayerRef:
		queue_free()
	
	_createWaypoints()
	
	HealthComponentNode.MaxHealth = MaxHealth
	SpeedComponentNode.Speed = Speed
	
	DamageComponentNode.AttackDamage = AttackDamage
	DamageComponentNode.AttackSpeed = AttackSpeed
	DamageComponentNode.DetectionRange = DetectionRange
	DamageComponentNode.AttackRange = AttackRange
	

	
func _createWaypoints() -> void:
	for child in get_node(PatrolPoints).get_children():
		Waypoints.append(child.global_position)
		
# Updates movement for Navigation
# Using on States
func updateMovement() -> void:
	if NavigationAgent.is_navigation_finished(): 
		return
	else:
		var NextPathPosition: Vector3 = NavigationAgent.get_next_path_position()
		var LocalDestination = NextPathPosition - global_position
		var Direction = LocalDestination.normalized()
	
		velocity = Direction * SpeedComponentNode.Speed
	
func canSeePlayer(ViewRange: float) -> bool:
	var ParentPos: Vector3 = global_position
	var PlayerPos: Vector3 = PlayerRef.global_position
	
	var Distance = ParentPos.distance_to(PlayerPos)
	
	return Distance <= ViewRange
