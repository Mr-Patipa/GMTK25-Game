extends StaticBody3D
class_name TurretEnemy

@onready var AttackComponentNode: AttackComponent = $AttackComponent

@export_group("Object References")
@export var PlayerRef : Player

@export_group("Range Settings")
@export var DetectionRange: float = 20.0

@export_group("Combat")
@export var Damage: int = 10
@export var BulletSpeed: float = 4.0

func _ready() -> void:
	# Pass exported values into the attack component
	AttackComponentNode.Damage = Damage
	AttackComponentNode.BulletSpeed = BulletSpeed

func can_see_player(ViewRange: float) -> bool:
	var ParentPos: Vector3 = global_position
	var PlayerPos: Vector3 = PlayerRef.global_position
	
	var Distance = ParentPos.distance_to(PlayerPos)
	
	return Distance <= ViewRange
