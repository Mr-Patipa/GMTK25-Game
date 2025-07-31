extends Camera3D

var y_lock: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	y_lock = self.global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.y = y_lock
