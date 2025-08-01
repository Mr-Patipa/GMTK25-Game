extends CharacterBody3D
class_name AngryEnemy

@onready var DebugLabel: Label3D = $DebugLabel
@onready var NavigationAgent: NavigationAgent3D = $NavigationAgent
@onready var LifeTimer: Timer = $LifeTimer

# Componets
@onready var AttackComponentNode: AttackComponent = $AttackComponent

@export_group("General")
@export var LifeTime : float = 30.0
@export var WalkSpeed : float = 10.0

@export_group("Object References")
@export var PlayerRef : Player

@export_group("Range Settings")
@export var DetectionRange: float = 10.0
@export var AttackRange: float = 2.0

@export_group("Combat")
@export var Damage: int = 10
@export var AttackCooldown: float = 2.0

func _ready() -> void:
	if !PlayerRef:
		queue_free()
		
	LifeTimer.start(LifeTime)
	
	# Pass exported values into the attack component
	AttackComponentNode.Damage = Damage
	AttackComponentNode.AttackCooldown = AttackCooldown
	
func _process(_delta: float) -> void:
	DebugLabel.text = str(round(LifeTimer.time_left))
	
func _on_life_timer_timeout() -> void:
	queue_free()
	
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
		
func can_see_player(ViewRange: float) -> bool:
	var ParentPos: Vector3 = global_position
	var PlayerPos: Vector3 = PlayerRef.global_position
	
	var Distance = ParentPos.distance_to(PlayerPos)
	
	return Distance <= ViewRange
