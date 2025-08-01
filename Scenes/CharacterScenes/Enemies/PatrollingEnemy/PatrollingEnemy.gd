extends CharacterBody3D
class_name PatrollingMonster

@onready var NavigationAgent: NavigationAgent3D = $NavigationAgent

@export var PlayerRef : Player
@export var WalkSpeed : float = 10.0
@export var DetectionRange: float = 100.0
@export var PatrolPoints: NodePath

var Waypoints: Array[Vector3] = []
var CurrentWaypoint: int = 0

@onready var state_machine: StateMachine = $StateMachine
@onready var patrolling: Node = $StateMachine/Patrolling
@onready var chasing: Node = $StateMachine/Chasing
@onready var searching: Node = $StateMachine/Searching


func _ready() -> void:
	if !PlayerRef:
		queue_free()
	
	_createWaypoints()
	
func _createWaypoints() -> void:
	for child in get_node(PatrolPoints).get_children():
		Waypoints.append(child.global_position)
		
func _process(_delta: float) -> void:
	#print(state_machine.CurrentState)
	pass
	
# Updates movement for Navigation
# Using on States
func update_movement() -> void:
	if NavigationAgent.is_navigation_finished(): 
		return
	else:
		var NextPathPosition: Vector3 = NavigationAgent.get_next_path_position()
		var LocalDestination = NextPathPosition - global_position
		var Direction = LocalDestination.normalized()
	
		velocity = Direction * WalkSpeed
	
func can_see_player() -> bool:
	var ParentPos = global_position
	var PlayerPos = PlayerRef.global_position
	
	# var Direction = (PlayerRef.global_position - global_position).normalized()
	## Never Used
	var Distance = ParentPos.distance_to(PlayerPos)
	
	return Distance <= DetectionRange
