extends CharacterBody3D
class_name Bartender

var target: Vector3
var charging := false

@export var speed := 5



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if charging:
		move_and_collide((target - self.global_position).normalized() *speed*delta)
	
func charge() -> void:
	self.charging = true


func _on_area_3d_body_entered(body: Node3D) -> void:
	#print(body is Player)
	if body is not Player: return
	if body is Player:
		GameManager.player_collided.emit(body)

func checkBarrier(body: Node3D) -> void:
	if body == self:
		self.queue_free()
