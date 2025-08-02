extends Area3D
class_name Bullet

@onready var LifeTimer: Timer = $LifeTimer

# Bullet movement direction and speed
var Direction: Vector3 = Vector3(50, -50, -50)

var LifeTime: float = 10.0

func _ready() -> void:
	LifeTimer.wait_time = LifeTime
	LifeTimer.start()

func _process(delta: float) -> void:
	position += Direction * delta

func setup(StartPosition: Vector3, _Direction: Vector3, Speed: float) -> void:
	var AdjustedDirection = _Direction.normalized()
	
	# Reduce vertical drop
	AdjustedDirection.y *= 0.1 
	
	# Set direction and speed
	Direction = AdjustedDirection.normalized() * Speed
	
	# Set starting position
	global_position = StartPosition

func _on_area_entered(_area: Area2D) -> void:
	# Destroy bullet on collision
	queue_free()

func _on_life_timer_timeout() -> void:
	# Destroy bullet after period of time
	queue_free()
