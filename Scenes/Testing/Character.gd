extends CharacterBody3D
class_name PlayerTest


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var Player_Inventory: Array[String]

func _ready() -> void:
	self.Player_Inventory = []

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_item_collected_signal(n: String, a: int) -> void:
	# Triggered when collecting an item.
	# Hook up via signal from Item.gd's collectedSignal
	for i in range(a):
		self.Player_Inventory.append(n)
