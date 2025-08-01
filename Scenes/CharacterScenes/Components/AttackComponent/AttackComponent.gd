extends Node
class_name AttackComponent

@onready var AttackCooldownTimer: Timer = $AttackCooldown

var Damage: int = 10
var AttackCooldown: float = 2.0

# Range
var BulletSpeed: float = 5.0

var _CanAttack: bool = true

func _ready() -> void:
	AttackCooldownTimer.wait_time = AttackCooldown


func dealDamage(PlayerRef: Player) -> void:
	if _CanAttack:
		PlayerRef.takeDamage(Damage)
		resetTimer()


func shoot(ShootPosition: Vector3, Direction: Vector3) -> void:
	if _CanAttack:
		SignalHub.emit_on_create_bullet(
			ShootPosition, Direction,
			BulletSpeed,
		)
		resetTimer()
	
		
func resetTimer() -> void:
	_CanAttack = false
	AttackCooldownTimer.start()


func _on_attack_cooldown_timeout() -> void:
	_CanAttack = true
