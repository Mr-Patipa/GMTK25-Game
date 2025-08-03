extends StaticBody3D
class_name TurretEnemy

@onready var DamageComponentNode: DamageComponent = $DamageComponent
@onready var PlayerDetection: RayCast3D = $PlayerDetection

@export var IsOneDirection: bool = false
@export var HaveRandomAccuracy: bool = true

@export var BulletDirectionX: float = 0.0
@export var BulletDirectionZ: float = 1.0
@export var BulletAngleSpread:float = 15.0

@export_group("Object References")
@export var PlayerRef : Player

@export_group("Combat")
@export var AttackDamage: int = 10.0
@export var AttackSpeed: float = 2.0
@export var BulletSpeed: float = 4.0
@export var DetectionRange: float = 15.0
@export var AttackRange: float = 2.0


func _ready() -> void:
	DamageComponentNode.AttackDamage = AttackDamage
	DamageComponentNode.AttackSpeed = AttackSpeed
	DamageComponentNode.BulletSpeed = BulletSpeed
	DamageComponentNode.DetectionRange = DetectionRange
	DamageComponentNode.AttackRange = AttackRange

func _physics_process(delta: float) -> void:
	updateRaycast()

func updateRaycast() -> void:
	PlayerDetection.look_at(PlayerRef.global_position)
	
func playerIsVisible() -> bool:
	return PlayerDetection.get_collider() is Player
	
func canSeePlayer(ViewRange: float) -> bool:
	var CanSeePlayer: bool = false
	
	var ParentPos: Vector3 = global_position
	var PlayerPos: Vector3 = PlayerRef.global_position
	
	var Distance = ParentPos.distance_to(PlayerPos)
	
	if playerIsVisible() and (Distance <= ViewRange):
		CanSeePlayer = true
	
	return CanSeePlayer
