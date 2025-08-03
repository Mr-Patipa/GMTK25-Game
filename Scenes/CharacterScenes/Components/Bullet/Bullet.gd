extends Area3D
class_name Bullet

@onready var LifeTimer: Timer = $LifeTimer

var _Direction: Vector3 = Vector3(50, -50, -50)
var _Damage: int = 0

var LifeTime: float = 10.0

func _ready() -> void:
	LifeTimer.wait_time = LifeTime
	LifeTimer.start()

func _process(delta: float) -> void:
	position += _Direction * delta

func setup(StartPosition: Vector3, Direction: Vector3, Speed: float, Damage: int) -> void:
	var AdjustedDirection = Direction.normalized()
	
	# Reduce vertical drop
	AdjustedDirection.y *= 0.0 
	
	# Set local variables
	_Direction = AdjustedDirection.normalized() * Speed
	_Damage = Damage
	
	# Set starting position
	global_position = StartPosition

func _on_body_entered(body: Node3D) -> void:
	# Destroy bullet on collision
	queue_free()
		


func _on_life_timer_timeout() -> void:
	# Destroy bullet after period of time
	queue_free()
