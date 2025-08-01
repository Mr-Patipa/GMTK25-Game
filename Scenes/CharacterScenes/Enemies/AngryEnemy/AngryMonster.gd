extends CharacterBody3D
class_name AngryMonster

@onready var DebugLabel: Label3D = $DebugLabel
@onready var NavigationAgent: NavigationAgent3D = $NavigationAgent
@onready var LifeTimer: Timer = $LifeTimer

@export var PlayerRef : Player
@export var WalkSpeed : float = 10.0
@export var LifeTime : float = 30.0
@export var DetectionRange: float = 100.0

func _ready() -> void:
	if !PlayerRef:
		queue_free()
		
	LifeTimer.start(LifeTime)
		
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
		
func can_see_player() -> bool:
	var ParentPos = global_position
	var PlayerPos = PlayerRef.global_position
	
	# var Direction = (PlayerRef.global_position - global_position).normalized()
	## Never Used
	var Distance = ParentPos.distance_to(PlayerPos)
	
	return Distance <= DetectionRange
