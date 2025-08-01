extends CharacterBody3D
class_name Player

@export var Mass : float = 80
@export var Force : float = 5
@export var WalkSpeed : float = 100
@export var JumpHieght : float = 400
@export var Gravity : float = 981
@export var Health : float = 100
@export var FacingDirection : Vector2
@export var Camera : Camera3D

func _physics_process(_delta: float) -> void:
	pushBlocks()

func pushBlocks() -> void:
	for node in get_slide_collision_count():
		var block = get_slide_collision(node)
		if block.get_collider() is RigidBody3D:
			var Direction = -block.get_normal()
			var Resistence = self.velocity.dot(Direction) - block.get_collider().linear_velocity.dot(Direction)
			Resistence = max(0, Resistence)
			var MassRatio = min(1, Mass / block.get_collider().mass)
			Direction.y = 0
			
			var PushForce = MassRatio * Force
			block.get_collider().apply_impulse(Direction * Resistence * PushForce, block.get_position() - block.get_collider().global_position)
			
